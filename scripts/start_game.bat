@echo off
setlocal

echo [*] Initializing CyberArena Infrastructure...

REM 1. Check Dependencies
where cargo >nul 2>nul
if %errorlevel% neq 0 (
    echo Rust is not installed.
    exit /b 1
)

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed.
    exit /b 1
)

REM 2. Build Server
echo [+] Building Rust Game Server...
REM Navigate to engine folder relative to this script
pushd ..\engine
cargo build --quiet
if %errorlevel% neq 0 (
    echo [!] Server build failed.
    popd
    exit /b 1
)

REM 3a. Start Server in a new window
echo [+] Starting Server...
start "CyberArena Server" cargo run --quiet
REM Return to scripts folder
popd 

REM 3b. Start Web App in a new window
echo [+] Starting Vulnerable Web App...
REM Navigate to web challenge folder
pushd ..\challenges\02-web-sqli
REM Start python in a new window named "CyberArena Web App"
start "CyberArena Web App" python web_challenge.py
REM Return to scripts folder
popd

REM Wait for services to boot
timeout /t 3 >nul

REM 4. Run Python Simulation
echo [*] Launching Python Game Admin Simulation...
REM We are already in 'scripts/' so we can just run the file
python -c "import httpx" 2>nul || pip install httpx
python game_admin.py

echo.
echo [*] Simulation complete. 
echo     - Close the "CyberArena Server" window manually.
echo     - Close the "CyberArena Web App" window manually.
pause