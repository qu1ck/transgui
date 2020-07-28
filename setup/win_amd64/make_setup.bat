@echo off

echo "Usage: %~nx0 <lazarus_dir> <inno_setup_dir>"

if "%1" NEQ "" (
    set "LAZARUS_DIR=%1"
) else (
    set "LAZARUS_DIR=D:\devtools\Lazarus"
)
echo "%2"
if "%2" NEQ "" (
    set ISC="%2"
) else (
    set "ISC=D:\devtools\Inno Setup 5"
)

set path=%LAZARUS_DIR%;%LAZARUS_DIR%\fpc\3.0.4\bin\x86_64-win64;D:\devtools\upx-3.96-win64;D:\devtools\zip;%path%

lazbuild -B ../../transgui.lpi
if errorlevel 1 goto err
make -C ../.. clean
if errorlevel 1 goto err
make -C ../.. all
if errorlevel 1 goto err

if not (%CODECERT%) == () (
  signtool.exe sign /d "Transmission Remote GUI" /du "https://github.com/transmission-remote-gui/transgui" /f "%CODECERT%" /v ..\..\transgui.exe
  if errorlevel 1 goto err
)

REM "%ISC%\iscc.exe" "/ssigntool=signtool.exe $p" setup.iss
"%ISC%\iscc.exe" setup.iss
if errorlevel 1 goto err

pause
exit /b 0

:err
pause
exit /b 1
