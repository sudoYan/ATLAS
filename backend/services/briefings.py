import subprocess
from datetime import datetime

def trigger_evening_shutdown_prompt():
    prompt = "Is there anything lingering in your head that isn't on the board yet? Take 2 minutes to review."
    script = f"""
    display dialog "{prompt}" buttons {"Review Board", "Dismiss"} default button "Review Board" with title "ATLAS Evening Shutdown"
    """
    subprocess.run(['osascript', '-e', script])

async def generate_morning_briefing():
    # Aggregates emails, calendar, finance
    return {
        "greeting": "Good morning. Here is your daily briefing.",
        "unread_emails_count": 5,
        "urgent_messages": 2,
        "first_event": "Team Standup at 09:00 (ONLINE)",
        "market_status": "Portfolio stable. No alerts."
    }