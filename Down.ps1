$videoURL = Read-Host "Enter video URL"
$basename = Read-Host "Enter base filename"
$mkvName = "$basename.mkv"

# Download base video
yt-dlp -f "bv*+ba[language=en]/best" -o "$basename.%(ext)s" $videoURL

# Audio
yt-dlp -f "bestaudio[language=es]" -o "$basename.spa.m4a" $videoURL
yt-dlp -f "bestaudio[language=fr]" -o "$basename.fra.m4a" $videoURL

# Subtitles
yt-dlp --write-subs --sub-lang "en" --skip-download --convert-subs srt -o "$basename.eng.srt" $videoURL
yt-dlp --write-subs --sub-lang "es" --skip-download --convert-subs srt -o "$basename.spa.srt" $videoURL
yt-dlp --write-subs --sub-lang "fr" --skip-download --convert-subs srt -o "$basename.fra.srt" $videoURL

# Detect video file
$videoFile = Get-ChildItem "$basename.*" | Where-Object { $_.Extension -match '\.(mp4|webm|mkv)' } | Select-Object -First 1

# Merge with ffmpeg
ffmpeg -i $videoFile.Name `
  -i "$basename.spa.m4a" -i "$basename.fra.m4a" `
  -i "$basename.eng.srt" -i "$basename.spa.srt" -i "$basename.fra.srt" `
  -map 0:v:0 -map 0:a:0 -map 1:a:0 -map 2:a:0 `
  -map 3 -map 4 -map 5 `
  -c:v copy -c:a aac -c:s srt `
  -metadata:s:a:0 language=eng -metadata:s:a:0 title="English" `
  -metadata:s:a:1 language=spa -metadata:s:a:1 title="Spanish" `
  -metadata:s:a:2 language=fra -metadata:s:a:2 title="French" `
  -metadata:s:s:0 language=eng -metadata:s:s:0 title="English Subtitles" `
  -metadata:s:s:1 language=spa -metadata:s:s:1 title="Spanish Subtitles" `
  -metadata:s:s:2 language=fra -metadata:s:s:2 title="French Subtitles" `
  -disposition:a:0 default `
  "$mkvName"

Write-Host "✅ Merged output: $mkvName"
