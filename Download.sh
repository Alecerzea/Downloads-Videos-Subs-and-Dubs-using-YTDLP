#!/bin/bash

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "[!] yt-dlp not found. Installing via pip..."
    python3 -m pip install -U yt-dlp || { echo "[X] Failed to install yt-dlp. Please install manually."; exit 1; }
fi

# Prompt for video URL
read -rp "Enter video URL: " mediaURL

# Prompt for download mode
echo ""
echo "Choose download mode:"
echo "1 - Video only (no subtitles)"
echo "2 - Video with embedded subtitles"
echo "3 - Video with audio dub + embedded subtitles"
echo "4 - Video and subtitles separately (subs external)"
echo "5 - Video with audio dub ONLY (no subtitles)"
read -rp "Enter choice (1/2/3/4/5): " mode

if [[ ! "$mode" =~ ^[1-5]$ ]]; then
    echo "Invalid mode selected."
    exit 1
fi

subLang=""
audioLang=""

# Subtitle language for modes 2 and 4
if [[ "$mode" == "2" || "$mode" == "4" ]]; then
    echo ""
    echo "Choose subtitle language:"
    echo "1 - Latin American Spanish (es-419)"
    echo "2 - English (en)"
    read -rp "Enter choice (1/2): " subChoice
    case "$subChoice" in
        1) subLang="es-419" ;;
        2) subLang="en" ;;
        *) echo "Invalid subtitle language choice."; exit 1 ;;
    esac
fi

# Audio and subtitle language for mode 3
if [[ "$mode" == "3" ]]; then
    echo ""
    echo "Choose audio language:"
    echo "1 - Latin American Spanish (es)"
    echo "2 - English (en)"
    read -rp "Enter choice (1/2): " audioChoice
    case "$audioChoice" in
        1) audioLang="es" ;;
        2) audioLang="en" ;;
        *) echo "Invalid audio language choice."; exit 1 ;;
    esac

    echo ""
    echo "Choose subtitle language:"
    echo "1 - Latin American Spanish (es-419)"
    echo "2 - English (en)"
    read -rp "Enter choice (1/2): " subChoice
    case "$subChoice" in
        1) subLang="es-419" ;;
        2) subLang="en" ;;
        *) echo "Invalid subtitle language choice."; exit 1 ;;
    esac
fi

# Audio language for mode 5
if [[ "$mode" == "5" ]]; then
    echo ""
    echo "Choose audio language:"
    echo "1 - Latin American Spanish (es)"
    echo "2 - English (en)"
    read -rp "Enter choice (1/2): " audioChoice
    case "$audioChoice" in
        1) audioLang="es" ;;
        2) audioLang="en" ;;
        *) echo "Invalid audio language choice."; exit 1 ;;
    esac
fi

# Generate filename with timestamp
timestamp=$(date +%s)
filename="download_$timestamp"

echo ""
echo "Starting download..."

# Execute yt-dlp command based on mode
case "$mode" in
    1)
        yt-dlp -o "${filename}.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" "$mediaURL"
        ;;
    2)
        yt-dlp -o "${filename}.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "$subLang" --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" "$mediaURL"
        ;;
    3)
        yt-dlp -o "${filename}.mp4" -f "bv*+ba[lang=${audioLang},ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "$subLang" --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" "$mediaURL"
        ;;
    4)
        yt-dlp -o "${filename}.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "$subLang" --convert-subs srt --user-agent "Mozilla/5.0" "$mediaURL"
        ;;
    5)
        yt-dlp -o "${filename}.mp4" -f "bv*+ba[lang=${audioLang},ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" "$mediaURL"
        ;;
esac

echo ""
echo "[✓] Download complete. File saved as ${filename}.mp4"