<#
.SYNOPSIS
    C3 Static & Text-Rule QA Validator for Paper LLM Wiki HTML Slides.
.DESCRIPTION
    Performs fast, browser-free static QA checks defined in workflows/slide-graph.md:
    - Slide count & required metadata (data-title, data-notes, slide-footer)
    - Offline check (zero external CDN http/https src/href dependencies)
    - HTML structural tag balance (section, div, svg)
    - Per-slide visible character & bullet count overflow guard
    - Visual diversity ratio & consecutive text-only slide guard
.EXAMPLE
    .\scripts\validate-slides.ps1 -HtmlPath ".\slides\2026-11-23-llm-synthetic-qa-critique-pipeline.html" -ExpectedSlides 11
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$HtmlPath,

    [int]$ExpectedSlides = 0,
    [int]$MaxVisualUnits = 520,
    [int]$WarnVisualUnits = 440,
    [int]$MaxBullets = 10,
    [double]$MinVisualRatio = 0.5
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $HtmlPath)) {
    Write-Error "File not found: $HtmlPath"
    exit 1
}

$html = Get-Content -Path $HtmlPath -Raw -Encoding UTF8

$n4Errors = New-Object System.Collections.Generic.List[string]
$mapErrors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

# 1. External CDN / network dependency check (exclude xmlns)
$extMatches = [regex]::Matches($html, '(?:src|href)\s*=\s*["'']https?://[^"'']+["'']', 'IgnoreCase')
if ($extMatches.Count -gt 0) {
    foreach ($m in $extMatches) {
        $n4Errors.Add("External dependency found (must be offline-ready): $($m.Value)")
    }
}

# 2. Structural tag balance check
foreach ($tag in @('section', 'div', 'svg')) {
    $openCount = [regex]::Matches($html, "<$tag\b", 'IgnoreCase').Count
    $closeCount = [regex]::Matches($html, "</$tag>", 'IgnoreCase').Count
    if ($openCount -ne $closeCount) {
        $n4Errors.Add("Unbalanced <$tag> tags: open=$openCount, close=$closeCount")
    }
}

# 3. Extract <section class="slide ..."> blocks
$slideMatches = [regex]::Matches($html, '<section\b[^>]*class="[^"]*\bslide\b[^"]*"[^>]*>[\s\S]*?</section>', 'IgnoreCase')
$slideCount = $slideMatches.Count

if ($slideCount -eq 0) {
    $n4Errors.Add("No <section class='slide'> elements found.")
}
if ($ExpectedSlides -gt 0 -and $slideCount -ne $ExpectedSlides) {
    $n4Errors.Add("Slide count mismatch: found $slideCount, expected $ExpectedSlides.")
}

$visualSlides = 0
$nonCoverCount = 0
$consecutiveTextOnly = 0
$maxConsecutiveTextOnly = 0
$perSlideReport = @()

for ($i = 0; $i -lt $slideCount; $i++) {
    $idx = $i + 1
    $block = $slideMatches[$i].Value
    $isCover = $block -match 'class="[^"]*\bcover\b[^"]*"'

    $titleMatch = [regex]::Match($block, 'data-title="([^"]*)"')
    $notesMatch = [regex]::Match($block, 'data-notes="([^"]*)"')
    $hasTitle = $titleMatch.Success -and ($titleMatch.Groups[1].Value.Trim().Length -gt 0)
    $hasNotes = $notesMatch.Success -and ($notesMatch.Groups[1].Value.Trim().Length -gt 0)

    if (-not $hasTitle) { $n4Errors.Add("Slide ${idx}: missing or empty data-title.") }
    if (-not $hasNotes) { $mapErrors.Add("Slide ${idx}: missing or empty data-notes (speaker notes).") }

    # Check footer on non-cover slides
    $hasFooter = $block -match '<footer\b[^>]*class="[^"]*slide-footer[^"]*"'
    if (-not $isCover -and -not $hasFooter) {
        $n4Errors.Add("Slide ${idx}: missing <footer class='slide-footer'> for source & page number.")
    }

    # Visible text measurement (remove footer, svg text, and html tags)
    # Use visual width units: non-ASCII (CJK/fullwidth) = 1.0, ASCII = 0.5
    $bodyOnly = [regex]::Replace($block, '<footer[\s\S]*?</footer>', '')
    $bodyOnly = [regex]::Replace($bodyOnly, '<svg[\s\S]*?</svg>', '')
    $plainText = [regex]::Replace($bodyOnly, '<[^>]+>', ' ')
    $plainText = [System.Net.WebUtility]::HtmlDecode($plainText)
    $plainText = [regex]::Replace($plainText, '\s+', ' ').Trim()
    $cjkCount = [regex]::Matches($plainText, '[^\x00-\x7F]').Count
    $asciiCount = $plainText.Length - $cjkCount
    $visualUnits = [int][math]::Ceiling($cjkCount + ($asciiCount * 0.5))

    # Bullet count
    $bulletCount = [regex]::Matches($block, '<li\b', 'IgnoreCase').Count

    if ($visualUnits -gt $MaxVisualUnits) {
        $mapErrors.Add("Slide ${idx}: visible text overflow ($visualUnits visual units > max $MaxVisualUnits).")
    } elseif ($visualUnits -gt $WarnVisualUnits) {
        $warnings.Add("Slide ${idx}: text density is high ($visualUnits visual units > warn $WarnVisualUnits); consider tightening.")
    }
    if ($bulletCount -gt $MaxBullets) {
        $mapErrors.Add("Slide ${idx}: too many bullets ($bulletCount > max $MaxBullets).")
    }

    # Visual diversity check
    $hasVisual = ($block -match '<svg\b') -or
                 ($block -match '<table\b') -or
                 ($block -match 'chart-group') -or
                 ($block -match 'stat-row') -or
                 ($block -match 'diagram-box') -or
                 ($block -match 'pill-row') -or
                 ($block -match 'grid-4')

    if (-not $isCover) {
        $nonCoverCount++
        if ($hasVisual) {
            $visualSlides++
            $consecutiveTextOnly = 0
        } else {
            $consecutiveTextOnly++
            if ($consecutiveTextOnly -gt $maxConsecutiveTextOnly) {
                $maxConsecutiveTextOnly = $consecutiveTextOnly
            }
        }
    }

    $perSlideReport += [PSCustomObject]@{
        Slide   = "{0:D2}" -f $idx
        VUnits  = $visualUnits
        Bullets = $bulletCount
        Visual  = if ($isCover) { "Cover" } elseif ($hasVisual) { "Yes" } else { "Text" }
        Notes   = if ($hasNotes) { "OK" } else { "MISS" }
        Title   = if ($hasTitle) { $titleMatch.Groups[1].Value } else { "(missing)" }
    }
}

$visualRatio = if ($nonCoverCount -gt 0) { [math]::Round($visualSlides / $nonCoverCount, 2) } else { 0 }
if ($nonCoverCount -gt 0 -and $visualRatio -lt $MinVisualRatio) {
    $warnings.Add("Visual slide ratio is $visualRatio (< target $MinVisualRatio).")
}
if ($maxConsecutiveTextOnly -ge 3) {
    $mapErrors.Add("Found $maxConsecutiveTextOnly consecutive text-only slides (max allowed: 2).")
}

Write-Output "=== C3 Static Slide QA Report ==="
Write-Output "File: $HtmlPath"
Write-Output "Slides: $slideCount | Visual Ratio (non-cover): $($visualRatio * 100)% | Max Consecutive Text-Only: $maxConsecutiveTextOnly"
Write-Output ""
$perSlideReport | Format-Table -AutoSize | Out-String | Write-Output

if ($warnings.Count -gt 0) {
    Write-Output "WARNINGS:"
    $warnings | ForEach-Object { Write-Output "  - $_" }
    Write-Output ""
}

if ($n4Errors.Count -eq 0 -and $mapErrors.Count -eq 0) {
    Write-Output "RESULT: PASS (Route -> N5 Wiki Bookkeeping)"
    exit 0
} else {
    Write-Output "RESULT: FAIL"
    if ($n4Errors.Count -gt 0) {
        Write-Output "ROUTE -> N4 (HTML Renderer Fixes):"
        $n4Errors | ForEach-Object { Write-Output "  - $_" }
    }
    if ($mapErrors.Count -gt 0) {
        Write-Output "ROUTE -> Map / N3a (Per-Slide Content Revisions):"
        $mapErrors | ForEach-Object { Write-Output "  - $_" }
    }
    exit 1
}
