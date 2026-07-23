import subprocess
import sqlite3
import os
from datetime import datetime, timedelta
from core import llm

def get_unread_emails():
    script = """
    tell application "Mail"
        set theMessages to messages of inbox whose read status is false
        set output to {}
        repeat with msg in theMessages
            set end of output to {subject:subject of msg, sender:sender of msg, id:message id of msg, content:content of msg}
        end repeat
        return output
    end tell
    """
    result = subprocess.run(['osascript', '-e', script], capture_output=True, text=True)
    return result.stdout # Parse as JSON in production

def get_urgent_imessages(hours=24):
    db_path = os.path.expanduser("~/Library/Messages/chat.db")
    conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    cursor = conn.cursor()
    # Apple epoch starts at 2001-01-01 (978307200 seconds)
    since = int((datetime.now() - timedelta(hours=hours)).timestamp() + 978307200)
    query = """
        SELECT m.text, h.id as sender, m.date 
        FROM message m LEFT JOIN handle h ON m.handle_id = h.ROWID
        WHERE m.is_from_me = 0 AND m.text IS NOT NULL AND m.date > ?
        ORDER BY m.date DESC LIMIT 20
    """
    cursor.execute(query, (since,))
    messages = [{"sender": row[1], "text": row[0]} for row in cursor.fetchall()]
    
    # Rank urgency with lightweight local model
    prompt = f"Rank these messages by urgency (High, Medium, Low). Return JSON array: {messages}"
    # return llm.generate_structured(prompt, UrgencySchema, model="llama3.2")
    return messages

def create_mail_draft(subject: str, recipient: str, body: str):
    script = f"""
    tell application "Mail"
        set newMessage to make new outgoing message with properties {{subject:"{subject}", content:"{body}"}}
        tell newMessage
            make new to recipient at end of to recipients with properties {{address:"{recipient}"}}
        end tell
        activate
    end tell
    """
    subprocess.run(['osascript', '-e', script])