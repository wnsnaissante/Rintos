@echo off
echo Building multi-stage bootloader...

:: Stage 1 (Boot sector)
echo Building Stage 1...
nasm -f bin src\bootsector\boot.asm -o boot.bin
if errorlevel 1 (
    echo Error building stage 1
    pause
    exit /b 1
)

:: Stage 2 (Loader)
echo Building Stage 2...
nasm -f bin src\bootsector\loader.asm -o loader.bin
if errorlevel 1 (
    echo Error building stage 2
    pause
    exit /b 1
)

:: Create disk image (1.44MB floppy)
echo Creating disk image...
fsutil file createnew rintos.img 1474560 > nul

:: Write boot sector (using PowerShell for binary operations)
echo Writing boot sector...
powershell -Command "$boot = [System.IO.File]::ReadAllBytes('boot.bin'); $img = [System.IO.File]::ReadAllBytes('rintos.img'); [Array]::Copy($boot, 0, $img, 0, $boot.Length); [System.IO.File]::WriteAllBytes('rintos.img', $img)"

:: Write loader (starting from sector 2 = offset 512)
echo Writing loader...
powershell -Command "$loader = [System.IO.File]::ReadAllBytes('loader.bin'); $img = [System.IO.File]::ReadAllBytes('rintos.img'); [Array]::Copy($loader, 0, $img, 512, $loader.Length); [System.IO.File]::WriteAllBytes('rintos.img', $img)"

echo.
echo Build complete: rintos.img
echo Test with: qemu-system-x86_64 -fda rintos.img
echo.
pause 