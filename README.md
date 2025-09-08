# Download-Videos-with-subs-and-audio-using-ytdlp-

:: Download video

yt-dlp -f "bv*+ba[language=en]/best" -o "%(title)s.%(ext)s" "<VIDEO_URL>"

:: English subs

yt-dlp --write-subs --sub-lang "en" --skip-download --output "%(title)s.%(language)s.%(ext)s" "<VIDEO_URL>"

:: Spanish subs

yt-dlp --write-subs --sub-lang "es-419,es-la,es" --skip-download --output "%(title)s.%(language)s.%(ext)s" "<VIDEO_URL>"

:: English dub audio only

yt-dlp -f "bestaudio" -x --audio-format mp3 -o "%(title)s.en-dub.%(ext)s" "<VIDEO_URL>"

:: Spanish dub audio only

yt-dlp -f "bestaudio" -x --audio-format mp3 -o "%(title)s.es-dub.%(ext)s" "<VIDEO_URL>"
