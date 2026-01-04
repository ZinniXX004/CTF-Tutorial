#!/bin/bash

# ANSI Colors for nicer output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# CONFIGURATION
# We are in 'scripts/', so we go up one level (..) then into challenges
BINARY_CHALLENGE_DIR="../challenges/01-binary-pwn"

echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}     CYBER ARENA - ENVIRONMENT BUILDER        ${NC}"
echo -e "${CYAN}==============================================${NC}"

# CHECK DEPENDENCIES
if ! command -v gcc &> /dev/null; then
    echo -e "${RED}[!] Error: gcc is not installed.${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[!] Error: python3 is not installed.${NC}"
    exit 1
fi

# PHASE 1: VULNERABLE BINARY
echo -e "\n${CYAN}[1/3] Building Vulnerable Binary (vault.c)...${NC}"
echo -e "      Source: ${BINARY_CHALLENGE_DIR}/vault.c"

# Flags: No Stack Canary, Executable Stack, No PIE (easier addresses)
gcc "${BINARY_CHALLENGE_DIR}/vault.c" -o "${BINARY_CHALLENGE_DIR}/vault" \
    -fno-stack-protector \
    -z execstack \
    -no-pie \
    -Wno-deprecated-declarations

if [ $? -eq 0 ]; then
    echo -e "${GREEN}    [+] Success: ${BINARY_CHALLENGE_DIR}/vault created.${NC}"
else
    echo -e "${RED}    [!] Failed to build vault.c${NC}"
fi

# PHASE 2: PATCHED BINARY
echo -e "\n${CYAN}[2/3] Building Patched Binary (vault_patched.c)...${NC}"

if [ -f "${BINARY_CHALLENGE_DIR}/vault_patched.c" ]; then
    gcc "${BINARY_CHALLENGE_DIR}/vault_patched.c" -o "${BINARY_CHALLENGE_DIR}/vault_patched" \
        -fno-stack-protector \
        -z execstack \
        -no-pie \
        -Wno-deprecated-declarations
        
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}    [+] Success: ${BINARY_CHALLENGE_DIR}/vault_patched created.${NC}"
    else
        echo -e "${RED}    [!] Failed to compile vault_patched.c${NC}"
    fi
else
    echo -e "    [-] Skip: vault_patched.c not found."
fi

# PHASE 3: WEB DEPENDENCIES
echo -e "\n${CYAN}[3/3] Installing Python Web Dependencies...${NC}"
# Check if pip3 exists
if command -v pip3 &> /dev/null; then
    pip3 install flask requests --quiet
    echo -e "${GREEN}    [+] Success: Flask and Requests installed.${NC}"
else
    echo -e "${RED}    [!] Warning: pip3 not found. Run: sudo apt install python3-pip${NC}"
fi

echo -e "\n${CYAN}==============================================${NC}"
echo -e "${GREEN}       BUILD COMPLETE - READY TO PLAY         ${NC}"
echo -e "${CYAN}==============================================${NC}"