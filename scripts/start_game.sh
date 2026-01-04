#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}[*] Initializing CyberArena Infrastructure...${NC}"

# Ensure we are in the directory where the script is located
cd "$(dirname "$0")"

# 1. Check Dependencies
if ! command -v cargo &> /dev/null; then
    echo "Rust (cargo) is not installed."
    exit 1
fi
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed."
    exit 1
fi

# 2. Build and Run Server
echo -e "${GREEN}[+] Building Rust Game Server...${NC}"

# Navigate to engine directory
cd ../engine
cargo build --quiet

echo -e "${GREEN}[+] Starting Server (Background Mode)${NC}"
cargo run --quiet &
SERVER_PID=$!

# 3. Start Web Application
echo -e "${GREEN}[+] Starting Vulnerable Web App (Background Mode)${NC}"
# Navigate from engine to web challenge
cd ../challenges/02-web-sqli
# Run python in background, hide output to keep terminal clean
python3 web_challenge.py > /dev/null 2>&1 &
WEB_PID=$!

# Go back to scripts directory to run the admin bot
cd ../../scripts
sleep 3

# 4. Run Python Simulation
echo -e "${CYAN}[*] Launching Python Game Admin Simulation...${NC}"
python3 -c "import httpx" 2>/dev/null || pip install httpx
python3 game_admin.py

# 5. Cleanup
echo -e "${CYAN}[*] Shutting down infrastructure...${NC}"
# Kill both the Rust Server and the Python Web App
kill $SERVER_PID
kill $WEB_PID
echo -e "${GREEN}[+] Done.${NC}"