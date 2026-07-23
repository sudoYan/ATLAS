from fastapi import FastAPI, BackgroundTasks
from integrations import communications, calendar, finance
from services import briefings, file_watcher

app = FastAPI(title="ATLAS Local Backend", version="1.0.0")

# Start background watcher on startup
@app.on_event("startup")
def startup_event():
    file_watcher.start_watcher()

@app.get("/api/briefing/morning")
async def get_morning_briefing():
    return await briefings.generate_morning_briefing()

@app.get("/api/communications/unread")
async def get_unread():
    return communications.get_unread_emails()

@app.get("/api/calendar/upcoming")
async def get_calendar():
    return calendar.get_upcoming_events_with_buffers()

@app.post("/api/communications/draft")
async def create_draft(data: dict):
    communications.create_mail_draft(data['subject'], data['recipient'], data['body'])
    return {"status": "Draft created in Apple Mail"}

@app.get("/api/finance/check")
async def check_finance():
    # Load from ~/.atlas/config.json in production
    return finance.check_portfolio({"AAPL": (150.0, 200.0), "MSFT": (300.0, 450.0)})