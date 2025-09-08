# Requires PowerShell 5.1 or later

# Check if yt-dlp is installed
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "[!] yt-dlp not found. Attempting to install via pip..."
    try {
        python -m pip install -U yt-dlp
    } catch {
        Write-Host "[X] Failed to install yt-dlp. Please install it manually."
        exit 1
    }
}

# Prompt for video URL
$mediaURL = Read-Host "Enter video URL"

# Prompt for download mode
Write-Host ""
Write-Host "Choose download mode:"
Write-Host "1 - Video only (no subtitles)"
Write-Host "2 - Video with embedded subtitles"
Write-Host "3 - Video with audio dub + embedded subtitles"
Write-Host "4 - Video and subtitles separately (subs external)"
Write-Host "5 - Video with audio dub ONLY (no subtitles)"
$mode = Read-Host "Enter choice (1/2/3/4/5)"

if ($mode -notin '1','2','3','4','5') {
    Write-Host "Invalid mode selected."
    exit 1
}

# Initialize variables
$subLang = $null
$audioLang = $null

# Subtitle language for modes with subtitles
if ($mode -eq '2' -or $mode -eq '4') {
    Write-Host ""
    Write-Host "Choose subtitle language:"
    Write-Host "1 - Latin American Spanish (es-419)"
    Write-Host "2 - English (en)"
    $subChoice = Read-Host "Enter choice (1/2)"
    switch ($subChoice) {
        '1' { $subLang = 'es-419' }
        '2' { $subLang = 'en' }
        default {
            Write-Host "Invalid subtitle language choice."
            exit 1
        }
    }
}

# Audio and subtitle language for mode 3
if ($mode -eq '3') {
    Write-Host ""
    Write-Host "Choose audio language:"
    Write-Host "1 - Latin American Spanish (es)"
    Write-Host "2 - English (en)"
    $audioChoice = Read-Host "Enter choice (1/2)"
    switch ($audioChoice) {
        '1' { $audioLang = 'es' }
        '2' { $audioLang = 'en' }
        default {
            Write-Host "Invalid audio language choice."
            exit 1
        }
    }

    Write-Host ""
    Write-Host "Choose subtitle language:"
    Write-Host "1 - Latin American Spanish (es-419)"
    Write-Host "2 - English (en)"
    $subChoice = Read-Host "Enter choice (1/2)"
    switch ($subChoice) {
        '1' { $subLang = 'es-419' }
        '2' { $subLang = 'en' }
        default {
            Write-Host "Invalid subtitle language choice."
            exit 1
        }
    }
}

# Audio language for mode 5
if ($mode -eq '5') {
    Write-Host ""
    Write-Host "Choose audio language:"
    Write-Host "1 - Latin American Spanish (es)"
    Write-Host "2 - English (en)"
    $audioChoice = Read-Host "Enter choice (1/2)"
    switch ($audioChoice) {
        '1' { $audioLang = 'es' }
        '2' { $audioLang = 'en' }
        default {
            Write-Host "Invalid audio language choice."
            exit 1
        }
    }
}

# Generate filename with timestamp
$timestamp = [int][double]::Parse((Get-Date -UFormat %s))
$filename = "download_$timestamp"

Write-Host ""
Write-Host "Starting download..."

# Build yt-dlp command based on mode
switch ($mode) {
    '1' {
        & yt-dlp -o "$filename.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" $mediaURL
    }
    '2' {
        & yt-dlp -o "$filename.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang $subLang --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" $mediaURL
    }
    '3' {
        & yt-dlp -o "$filename.mp4" -f "bv*+ba[lang=$audioLang,ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang $subLang --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" $mediaURL
    }
    '4' {
        & yt-dlp -o "$filename.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang $subLang --convert-subs srt --user-agent "Mozilla/5.0" $mediaURL
    }
    '5' {
        & yt-dlp -o "$filename.mp4" -f "bv*+ba[lang=$audioLang,ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" $mediaURL
    }
}

Write-Host ""
Write-Host "[✓] Download complete. File saved as $filename.mp4"