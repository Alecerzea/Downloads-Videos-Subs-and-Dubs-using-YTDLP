#!/bin/bash

read -p "Enter video URL: " VIDEO_URL
read -p "Enter base filename: " BASENAME
MKV_NAME="$BASENAME.mkv"

# Download base video (with English audio)
yt-dlp -f "bv*+ba[language=en]/best" -o "$BASENAME.%(ext)s" "$VIDEO_URL"

# Download audio tracks
yt-dlp -f "bestaudio[language=es]" -o "$BASENAME.spa.m4a" "$VIDEO_URL"
yt-dlp -f "bestaudio[language=fr]" -o "$BASENAME.fra.m4a" "$VIDEO_URL"

# Download subtitles
yt-dlp --write-subs --sub-lang "en" --skip-download --convert-subs srt -o "$BASENAME.eng.srt" "$VIDEO_URL"
yt-dlp --write-subs --sub-lang "es" --skip-download --convert-subs srt -o "$BASENAME.spa.srt" "$VIDEO_URL"
yt-dlp --write-subs --sub-lang "fr" --skip-download --convert-subs srt -o "$BASENAME.fra.srt" "$VIDEO_URL"

# Detect main video filename (e.g., .mp4 or .webm)
VIDEO_FILE=$(ls "$BASENAME".* | grep -E "\.(mp4|webm|mkv)$" | head -n1)

# Merge with ffmpeg
ffmpeg -i "$VIDEO_FILE" \
  -i "$BASENAME.spa.m4a" -i "$BASENAME.fra.m4a" \
  -i "$BASENAME.eng.srt" -i "$BASENAME.spa.srt" -i "$BASENAME.fra.srt" \
  -map 0:v:0 -map 0:a:0 -map 1:a:0 -map 2:a:0 \
  -map 3 -map 4 -map 5 \
  -c:v copy -c:a aac -c:s srt \
  -metadata:s:a:0 language=eng -metadata:s:a:0 title="English" \
  -metadata:s:a:1 language=spa -metadata:s:a:1 title="Spanish" \
  -metadata:s:a:2 language=fra -metadata:s:a:2 title="French" \
  -metadata:s:s:0 language=eng -metadata:s:s:0 title="English Subtitles" \
  -metadata:s:s:1 language=spa -metadata:s:s:1 title="Spanish Subtitles" \
  -metadata:s:s:2 language=fra -metadata:s:s:2 title="French Subtitles" \
  -disposition:a:0 default \
  "$MKV_NAME"
