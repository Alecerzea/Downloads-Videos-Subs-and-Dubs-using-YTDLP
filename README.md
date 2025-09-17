# Download Videos with subs and Dub using ytdld

:: Download video

yt-dlp -f "bv*+ba[language=en]/best" -o "video_base.%(ext)s" "<VIDEO_URL>"

:: English Dub

yt-dlp -f "bestaudio[language=en]" -o "audio_en.%(ext)s" "<VIDEO_URL>"

:: Spanish Dub

yt-dlp -f "bestaudio[language=es]" -o "audio_es.%(ext)s" "<VIDEO_URL>"

:: French Dub

yt-dlp -f "bestaudio[language=fr]" -o "audio_fr.%(ext)s" "<VIDEO_URL>"

:: English Subtitles

yt-dlp --write-subs --sub-lang "en" --skip-download --convert-subs srt -o "subs_en.srt" "<VIDEO_URL>"

:: Spanish Subtitles

yt-dlp --write-subs --sub-lang "es" --skip-download --convert-subs srt -o "subs_es.srt" "<VIDEO_URL>"

:: French Subtitles

yt-dlp --write-subs --sub-lang "fr" --skip-download --convert-subs srt -o "subs_fr.srt" "<VIDEO_URL>"
