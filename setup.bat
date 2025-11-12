@echo off
echo ===================================================
echo     Script setup Armbian boot files cho S805
echo ===================================================
echo.

set /p DRIVE="Nhap drive letter cua SD card (vi du E): "
if "%DRIVE%"=="" (
    echo Loi: Phai nhap drive letter!
    pause
    exit /b 1
)

echo.
echo Dang setup cho drive %DRIVE%:\
echo.

REM Kiểm tra drive tồn tại
if not exist "%DRIVE%:\" (
    echo Loi: Khong tim thay drive %DRIVE%:\
    pause
    exit /b 1
)

REM Copy các file cần thiết
echo Buoc 1: Copy boot files...
copy aml_autoscript "%DRIVE%:\" >nul 2>&1
if errorlevel 1 echo Loi copy aml_autoscript
copy aml_autoscript.cmd "%DRIVE%:\" >nul 2>&1  
if errorlevel 1 echo Loi copy aml_autoscript.cmd
copy s805_autoscript "%DRIVE%:\" >nul 2>&1
if errorlevel 1 echo Loi copy s805_autoscript
copy s805_autoscript.cmd "%DRIVE%:\" >nul 2>&1
if errorlevel 1 echo Loi copy s805_autoscript.cmd
copy uEnv.txt "%DRIVE%:\" >nul 2>&1
if errorlevel 1 echo Loi copy uEnv.txt
copy meson8b-m201.dtb "%DRIVE%:\" >nul 2>&1
if errorlevel 1 echo Loi copy meson8b-m201.dtb

echo   ✓ Da copy cac boot files

REM Copy u-boot files
echo Buoc 2: Copy u-boot file...
copy u-boot.bin.sd.bin "%DRIVE%:\u-boot.bin" >nul 2>&1
if errorlevel 1 echo Loi copy u-boot.bin

echo   ✓ Da copy u-boot.bin

REM Tạo folder dtb
echo Buoc 3: Tao folder dtb...
if not exist "%DRIVE%:\dtb\" mkdir "%DRIVE%:\dtb\"
copy meson8b-m201.dtb "%DRIVE%:\dtb\" >nul 2>&1

echo   ✓ Da tao folder dtb va copy DTB file

echo.
echo ===================================================
echo               SETUP HOAN TAT!
echo ===================================================
echo.
echo Cac buoc tiep theo:
echo 1. Safely eject SD card khoi may tinh
echo 2. Cam SD card vao S805 box  
echo 3. Nhan giu nut Reset va cam nguon
echo 4. Giu Reset 10-15 giay roi tha ra
echo 5. Box se boot Armbian tu SD card
echo.
echo Luu y: 
echo - Neu khong boot duoc, thu doi ten file u-boot
echo - Co the sua file uEnv.txt de chon DTB khac
echo - Neu gap loi video, sua VMODE trong uEnv.txt
echo.
pause
