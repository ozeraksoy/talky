@echo off
REM ─────────────────────────────────────────────────────────────────────────────
REM Talky - Premiere Pro Altyazı Oluşturucu
REM Windows Kurulum Scripti
REM ─────────────────────────────────────────────────────────────────────────────

setlocal EnableDelayedExpansion

set EXTENSION_ID=com.talky.captioner
set CEP_DIR=%APPDATA%\Adobe\CEP\extensions
set INSTALL_DIR=%CEP_DIR%\%EXTENSION_ID%
set SCRIPT_DIR=%~dp0
set SOURCE_DIR=%SCRIPT_DIR%..

echo.
echo  ==========================================
echo    Talky - Altyazı Oluşturucu Kurulum
echo  ==========================================
echo.

REM ── 1. CEP klasörünü oluştur ────────────────────────────────────────────────
echo  ^> CEP extensions klasörü hazırlanıyor...
if not exist "%CEP_DIR%" mkdir "%CEP_DIR%"

REM ── 2. Eski kurulumu temizle ─────────────────────────────────────────────────
if exist "%INSTALL_DIR%" (
    echo  ^> Eski kurulum kaldırılıyor...
    rmdir /s /q "%INSTALL_DIR%"
)

REM ── 3. Plugin dosyalarını kopyala ────────────────────────────────────────────
echo  ^> Plugin dosyaları kopyalanıyor...
mkdir "%INSTALL_DIR%"
mkdir "%INSTALL_DIR%\lib"

xcopy /e /i /q "%SOURCE_DIR%\CSXS"   "%INSTALL_DIR%\CSXS\"
xcopy /e /i /q "%SOURCE_DIR%\client" "%INSTALL_DIR%\client\"
xcopy /e /i /q "%SOURCE_DIR%\host"   "%INSTALL_DIR%\host\"

if exist "%SOURCE_DIR%\.debug" (
    copy "%SOURCE_DIR%\.debug" "%INSTALL_DIR%\.debug"
)

echo  ^> Dosyalar kopyalandı: %INSTALL_DIR%

REM ── 4. CSInterface.js indir ──────────────────────────────────────────────────
echo  ^> CSInterface.js indiriliyor...
set CSINTERFACE_URL=https://raw.githubusercontent.com/Adobe-CEP/CEP-Resources/master/CEP_11.x/CEP_11.0/CSInterface.js
set CSINTERFACE_PATH=%INSTALL_DIR%\lib\CSInterface.js

powershell -Command "try { Invoke-WebRequest -Uri '%CSINTERFACE_URL%' -OutFile '%CSINTERFACE_PATH%' -UseBasicParsing; Write-Host '  OK CSInterface.js indirildi.' } catch { Write-Host '  WARN CSInterface.js indirilemedi. Manuel indirmeniz gerekebilir.' }"

REM ── 5. CEP Debug Modu (Registry) ─────────────────────────────────────────────
echo  ^> CEP debug modu etkinleştiriliyor...

for %%v in (9 10 11 12) do (
    reg add "HKCU\Software\Adobe\CSXS.%%v" /v PlayerDebugMode /t REG_SZ /d 1 /f >nul 2>&1
    echo    OK CSXS.%%v PlayerDebugMode = 1
)

REM ── 6. ffmpeg Kontrolü ───────────────────────────────────────────────────────
echo.
echo  ^> ffmpeg kontrol ediliyor...
where ffmpeg >nul 2>&1
if %errorlevel% == 0 (
    echo    OK ffmpeg mevcut (PATH'de bulundu)
) else (
    echo.
    echo    UYARI: ffmpeg BULUNAMADI!
    echo.
    echo    ffmpeg kurmak icin:
    echo    1. Winget ile (onerillen):
    echo       winget install ffmpeg
    echo.
    echo    2. Chocolatey ile:
    echo       choco install ffmpeg
    echo.
    echo    3. Manuel indirme:
    echo       https://www.gyan.dev/ffmpeg/builds/
    echo       (ffmpeg-release-full.7z indirin, PATH'e ekleyin)
    echo.
)

REM ── 7. Kurulum Özeti ─────────────────────────────────────────────────────────
echo.
echo  ==========================================
echo          KURULUM TAMAMLANDI!
echo  ==========================================
echo.
echo  Kurulum konumu:
echo    %INSTALL_DIR%
echo.
echo  Sonraki adımlar:
echo    1. Premiere Pro'yu yeniden baslatin
echo    2. Menu: Window ^> Extensions ^> Talky - Altyazi Olusturucu
echo    3. API anahtarinizi girin (platform.openai.com/api-keys)
echo.
echo  Sorun cikarsa:
echo    - Hata ayiklama: Chrome'da http://localhost:7777 adresini acin
echo    - README.md dosyasini okuyun
echo.

pause
