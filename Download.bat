@echo off
setlocal enabledelayedexpansion

REM Check if yt-dlp is installed
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo [!] yt-dlp not found. Attempting to install it with pip...
    python -m pip install -U yt-dlp
    if errorlevel 1 (
        echo [X] Failed to install yt-dlp. Please install it manually and try again.
        pause
        exit /b 1
    )
)

REM Ask for video URL
set /p mediaURL=Enter video URL: 

REM Show download mode options
echo.
echo Choose download mode:
echo 1 - Video only (no subtitles)
echo 2 - Video with embedded subtitles
echo 3 - Video with audio dub + embedded subtitles
echo 4 - Video and subtitles separately (subs external)
echo 5 - Video with audio dub ONLY (no subtitles)
set /p mode=Enter choice (1/2/3/4/5): 

REM Validate mode
if not "%mode%"=="1" if not "%mode%"=="2" if not "%mode%"=="3" if not "%mode%"=="4" if not "%mode%"=="5" (
    echo Invalid mode selected.
    pause
    exit /b 1
)

REM Initialize variables
set "subLang="
set "audioLang="

REM Subtitle language selection for modes with subtitles
if "%mode%"=="2" (
    echo.
    echo Choose subtitle language:
    echo 1 - Latin American Spanish (es-419)
    echo 2 - English (en)
    set /p subChoice=Enter choice (1/2): 
    if "%subChoice%"=="1" (
        set "subLang=es-419"
    ) else if "%subChoice%"=="2" (
        set "subLang=en"
    ) else (
        echo Invalid subtitle language choice.
        pause
        exit /b 1
    )
)

if "%mode%"=="4" (
    echo.
    echo Choose subtitle language:
    echo 1 - Latin American Spanish (es-419)
    echo 2 - English (en)
    set /p subChoice=Enter choice (1/2):
    if "%subChoice%"=="1" (
        set "subLang=es-419"
    ) else if "%subChoice%"=="2" (
        set "subLang=en"
    ) else (
        echo Invalid subtitle language choice.
        pause
        exit /b 1
    )
)

REM Audio and subtitle language selection for mode 3
if "%mode%"=="3" (
    echo.
    echo Choose audio language:
    echo 1 - Latin American Spanish (es)
    echo 2 - English (en)
    set /p audioChoice=Enter choice (1/2):
    if "%audioChoice%"=="1" (
        set "audioLang=es"
    ) else if "%audioChoice%"=="2" (
        set "audioLang=en"
    ) else (
        echo Invalid audio language choice.
        pause
        exit /b 1
    )

    echo.
    echo Choose subtitle language:
    echo 1 - Latin American Spanish (es-419)
    echo 2 - English (en)
    set /p subChoice=Enter choice (1/2):
    if "%subChoice%"=="1" (
        set "subLang=es-419"
    ) else if "%subChoice%"=="2" (
        set "subLang=en"
    ) else (
        echo Invalid subtitle language choice.
        pause
        exit /b 1
    )
)

REM Audio language selection for mode 5 (audio dub only)
if "%mode%"=="5" (
    echo.
    echo Choose audio language:
    echo 1 - Latin American Spanish (es)
    echo 2 - English (en)
    set /p audioChoice=Enter choice (1/2):
    if "%audioChoice%"=="1" (
        set "audioLang=es"
    ) else if "%audioChoice%"=="2" (
        set "audioLang=en"
    ) else (
        echo Invalid audio language choice.
        pause
        exit /b 1
    )
)

REM Generate timestamped filename
for /f "tokens=1" %%a in ('powershell -Command "(Get-Date -UFormat %%s)"') do set timestamp=%%a
set "filename=download_%timestamp%"

REM Download based on mode selection
echo.
echo Starting download...

if "%mode%"=="1" (
    yt-dlp -o "%filename%.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" "%mediaURL%"
) else if "%mode%"=="2" (
    yt-dlp -o "%filename%.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "%subLang%" --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" "%mediaURL%"
) else if "%mode%"=="3" (
    yt-dlp -o "%filename%.mp4" -f "bv*+ba[lang=%audioLang%,ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "%subLang%" --convert-subs srt --embed-subs --user-agent "Mozilla/5.0" "%mediaURL%"
) else if "%mode%"=="4" (
    yt-dlp -o "%filename%.mp4" -f "bv*+ba[ext=m4a]" --merge-output-format mp4 --write-subs --sub-lang "%subLang%" --convert-subs srt --user-agent "Mozilla/5.0" "%mediaURL%"
) else if "%mode%"=="5" (
    yt-dlp -o "%filename%.mp4" -f "bv*+ba[lang=%audioLang%,ext=m4a]" --merge-output-format mp4 --user-agent "Mozilla/5.0" "%mediaURL%"
)

echo.
echo [✓] Download complete. File saved as %filename%.mp4
pause