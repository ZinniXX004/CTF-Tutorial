import asyncio
import httpx
import random
import json

# Configuration
SERVER_URL = "http://localhost:3000"
TEAMS = ["RedTeam", "BlueTeam", "GreenTeam", "ShadowBrokers"]
FLAGS = ["CTF{welcome_to_rust}", "CTF{buffer_overflow_ez}", "CTF{wrong_flag}"]

async def submit_flag(client, team, flag):
    """Simulates a team submitting a flag"""
    payload = {"team_name": team, "flag": flag}
    try:
        response = await client.post(f"{SERVER_URL}/submit", json=payload)
        print(f"[{team}] Submitting '{flag}' -> Status: {response.status_code} | {response.text}")
    except Exception as e:
        print(f"Server Down? Error: {e}")

async def monitor_scoreboard(client):
    """Fetches the scoreboard"""
    try:
        response = await client.get(f"{SERVER_URL}/scoreboard")
        data = response.json()
        print("\n--- LIVE SCOREBOARD ---")
        for idx, entry in enumerate(data):
            print(f"{idx+1}. {entry['team_name']}: {entry['score']} pts")
        print("-----------------------\n")
    except Exception as e:
        print(f"Could not fetch scoreboard: {e}")

async def simulation_loop():
    """Simulates a live CTF match"""
    async with httpx.AsyncClient() as client:
        print("Starting CTF Simulation...")
        
        # Simulate 5 rounds of activity
        for _ in range(5):
            # Pick a random team and a random flag
            team = random.choice(TEAMS)
            flag = random.choice(FLAGS)
            
            await submit_flag(client, team, flag)
            await asyncio.sleep(0.5) # Wait a bit
            
        await monitor_scoreboard(client)

if __name__ == "__main__":
    # Ensure dependencies are installed: pip install httpx
    try:
        asyncio.run(simulation_loop())
    except KeyboardInterrupt:
        print("Simulation stopped.")
