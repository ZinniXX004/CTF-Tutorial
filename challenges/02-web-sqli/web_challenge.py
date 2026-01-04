import sqlite3
import os
from flask import Flask, request, render_template_string

app = Flask(__name__)
DB_NAME = "staff.db"
FLAG = "CTF{sql_injection_master}"

# HTML Template for the Login Page
LOGIN_PAGE = """
<!doctype html>
<html>
<head><title>Staff Portal</title></head>
<body style="font-family: sans-serif; text-align: center; margin-top: 50px;">
    <h1>Staff Login Portal</h1>
    <div style="border: 1px solid #ccc; display: inline-block; padding: 20px;">
        <form method="POST">
            <label>Username:</label><br>
            <input type="text" name="username"><br><br>
            <label>Password:</label><br>
            <input type="password" name="password"><br><br>
            <input type="submit" value="Login">
        </form>
    </div>
    {% if message %}
        <p style="color: red;">{{ message }}</p>
    {% endif %}
</body>
</html>
"""

DASHBOARD_PAGE = """
<!doctype html>
<html>
<body style="font-family: sans-serif; text-align: center; margin-top: 50px; background-color: #e0ffe0;">
    <h1>Access Granted</h1>
    <h2>Welcome, {{ username }}!</h2>
    <p>Here is your secret flag:</p>
    <h3 style="color: green;">{{ flag }}</h3>
</body>
</html>
"""

def init_db():
    """Create a dummy database with one admin user"""
    if os.path.exists(DB_NAME):
        os.remove(DB_NAME)
        
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    c.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)")
    # We insert the Admin with a Super Secure Password
    c.execute("INSERT INTO users (username, password) VALUES ('admin', 'SuperSecureP@ssw0rd123')")
    conn.commit()
    conn.close()
    print(f"[*] Database {DB_NAME} initialized.")

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # THE VULNERABILITY 
        query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
        
        print(f"[DEBUG] Executing Query: {query}") # Show this in terminal for learning
        
        conn = sqlite3.connect(DB_NAME)
        c = conn.cursor()
        try:
            # Execute the query exactly as written
            c.execute(query)
            user = c.fetchone()
            
            if user:
                return render_template_string(DASHBOARD_PAGE, username=user[1], flag=FLAG)
            else:
                return render_template_string(LOGIN_PAGE, message="Invalid Credentials")
        except Exception as e:
            return render_template_string(LOGIN_PAGE, message=f"Database Error: {e}")
        finally:
            conn.close()
            
    return render_template_string(LOGIN_PAGE)

if __name__ == '__main__':
    init_db()
    print("[*] Web Server running on http://127.0.0.1:5000")
    app.run(port=5000, debug=False) # debug=False to keep output clean
