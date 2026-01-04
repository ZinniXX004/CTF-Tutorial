@echo off
setlocal enableextensions

echo ==============================================
echo      CYBER ARENA - ENVIRONMENT BUILDER
echo ==============================================

REM CONFIGURATION
REM We are in 'scripts/', so we go up one level (..) then into challenges
set "BINARY_CHALLENGE_DIR=..\challenges\01-binary-pwn"

REM CHECK DEPENDENCIES
where gcc >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Error: GCC is not found.
    echo Please install MinGW or w64devkit and add to PATH.
    exit /b 1
)

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Error: Python is not found.
    echo Please install Python 3.
    exit /b 1
)

REM PHASE 1: VULNERABLE BINARY
echo.
echo [1/3] Building Vulnerable Binary (vault.c)...
echo       Source: %BINARY_CHALLENGE_DIR%\vault.c

REM Flags: -fno-stack-protector (Disable Canary), -static (Portable)
gcc "%BINARY_CHALLENGE_DIR%\vault.c" -o "%BINARY_CHALLENGE_DIR%\vault.exe" -fno-stack-protector -Wno-deprecated-declarations -static

if %errorlevel% equ 0 (
    echo     [+] Success: vault.exe created in challenges folder.
) else (
    echo     [!] Failed to build vault.c
)

REM PHASE 2: PATCHED BINARY
echo.
echo [2/3] Building Patched Binary (vault_patched.c)...

if exist "%BINARY_CHALLENGE_DIR%\vault_patched.c" (
    gcc "%BINARY_CHALLENGE_DIR%\vault_patched.c" -o "%BINARY_CHALLENGE_DIR%\vault_patched.exe" -fno-stack-protector -Wno-deprecated-declarations -static
    if %errorlevel% equ 0 (
        echo     [+] Success: vault_patched.exe created in challenges folder.
    ) else (
        echo     [!] Failed to compile vault_patched.c
    )
) else (
    echo     [-] Skip: vault_patched.c not found in %BINARY_CHALLENGE_DIR%.
)

REM PHASE 3: WEB DEPENDENCIES
echo.
echo [3/3] Installing Python Web Dependencies...
pip install flask requests --quiet

if %errorlevel% equ 0 (
    echo     [+] Success: Flask and Requests installed.
) else (
    echo     [!] Warning: Could not install Python libraries.
)

echo.
echo ==============================================
echo        BUILD COMPLETE - READY TO PLAY
echo ==============================================
pause