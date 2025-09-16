#!/bin/bash

# Ensure ffmpeg is installed
command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "❌ FFmpeg not found. Install it first."; exit 1; }

# Auto-detect the video file (most likely .mp4 or .mkv)
VIDEO=$(ls *.mp4 *.mkv 2>/dev/null | grep -i -m 1 "video\|base\|main\|english")
if [[ -z "$VIDEO" ]]; then
  VIDEO=$(ls *.mp4 *.mkv 2>/dev/null | head -n 1)
fi

# Auto-detect Spanish and French dubs
AUDIO_ES=$(ls *es*.* 2>/dev/null | grep -i -m 1 "audio\|dub\|es")
AUDIO_FR=$(ls *fr*.* 2>/dev/null | grep -i -m 1 "audio\|dub\|fr")

# Check if required files exist
if [[ ! -f "$VIDEO" ]]; then
  echo "❌ No video file found (.mp4 or .mkv)."
  exit 1
fi

if [[ ! -f "$AUDIO_ES" ]]; then
  echo "❌ No Spanish audio file found (matching *es*)."
  exit 1
fi

if [[ ! -f "$AUDIO_FR" ]]; then
  echo "❌ No French audio file found (matching *fr*)."
  exit 1
fi

# Output file
OUTPUT="final_output.mkv"

echo "🔍 Using:"
echo "   🎞️ Video      : $VIDEO"
echo "   🇪🇸 Spanish Dub: $AUDIO_ES"
echo "   🇫🇷 French Dub : $AUDIO_FR"
echo "➡️  Muxing into  : $OUTPUT"

# Mux everything with language metadata
ffmpeg -i "$VIDEO" \
       -i "$AUDIO_ES" \
       -i "$AUDIO_FR" \
       -map 0:v -map 0:a -metadata:s:a:0 language=eng \
       -map 1:a -metadata:s:a:1 language=spa \
       -map 2:a -metadata:s:a:2 language=fra \
       -c:v copy -c:a aac \
       -y "$OUTPUT"

echo "✅ Done! Created: $OUTPUT"
