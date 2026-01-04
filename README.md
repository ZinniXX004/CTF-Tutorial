# 🚩 Cyber Arena: CTF & Attack-Defense Game

![Rust](https://img.shields.io/badge/Rust-server-orange)
![Python](https://img.shields.io/badge/Python-exploits-blue)
![C](https://img.shields.io/badge/C-binary-00599C)
![License](https://img.shields.io/badge/License-Educational-green)

**Cyber Arena** is a hands-on cybersecurity simulation designed to teach the fundamentals of **Capture The Flag (CTF)** competitions and **Attack & Defense** mechanics.

It features a custom high-performance **Scoreboard Server** (written in Rust), **Binary Exploitation** challenges (C), and **Web Application** vulnerabilities (Python/Flask).

---

## 📂 Project Structure

```text
/
├── engine/           # The Game Server (Rust + Axum)
├── challenges/       # Vulnerable source code
│   ├── 01-binary-pwn # Buffer Overflow Challenge (C)
│   └── 02-web-sqli   # SQL Injection Challenge (Python)
├── solutions/        # Automated exploit scripts (Python)
└── scripts/          # Build tools and Game Launchers
```

## 🛠️ Prerequisites

Before running the simulation, ensure you have the following installed:

* **Rust**: [Install Rust](https://www.rust-lang.org/tools/install)
* **Python 3**: [Install Python](https://www.python.org/downloads/)
* **GCC Compiler**:
    * **Windows**: Install [MinGW-w64](https://www.mingw-w64.org/) or [w64devkit](https://github.com/skeeto/w64devkit). *Make sure to add it to your PATH.*
    * **Linux/Mac**: Run `sudo apt install build-essential`

---

## 🚀 How to Play

### 1. Build the Environment
We provide automated scripts to compile the C binaries, patch the vulnerabilities, and install Python dependencies (Flask/Requests).

**Windows:**
```cmd
cd scripts
build_challenge.bat
```

**Linux/Mac:**
```bash
cd scripts
chmod +x build_challenge.sh
./build_challenge.sh
```
*(Alternatively, you can run `python build.py` inside the scripts folder).*

### 2. Start the Game
This script launches the Rust Scoreboard, the Vulnerable Web App, and a Simulation Bot (Game Admin) that generates traffic.

> **Note:** This will open new terminal windows for the Server and Web App. **Keep them open!**

**Windows:**
```cmd
cd scripts
start_game.bat
```

**Linux/Mac:**
```bash
cd scripts
chmod +x start_game.sh
./start_game.sh
```

### 3. Run the Exploits (The "Hacker" Mode)
Now that the infrastructure is running, open a **new** terminal and run the solution scripts to attack the challenges and capture flags.

#### Phase 1: Binary Exploitation (Buffer Overflow)
This script detects your OS, finds the vault binary, brute-forces the memory offset, and submits the flag.

```bash
cd solutions
python exploit_vault.py
```

#### Phase 2: Web Exploitation (SQL Injection)
This script attacks the running Web App (`localhost:5000`), bypasses the login, steals the flag, and submits it.

```bash
cd solutions
python exploit_web.py
```

---

## 🏆 Scoring

Check the **"CyberArena Server"** window to see your live score!

| Challenge Type | Vulnerability | Points |
| :--- | :--- | :--- |
| **Binary** | Buffer Overflow | **300** |
| **Web** | SQL Injection | **500** |

---

## 🛡️ Important Note

This project is intended for **educational purposes only**. The authors are not responsible for any misuse of the techniques demonstrated in this repository.