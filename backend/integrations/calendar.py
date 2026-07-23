from Foundation import NSObject
from EventKit import EKEventStore, EKEntityTypeEvent
from datetime import datetime, timedelta

def get_upcoming_events_with_buffers(hours=48):
    store = EKEventStore.alloc().init()
    end_date = datetime.now() + timedelta(hours=hours)
    predicate = store.predicateForEventsWithStartDate_endDate_calendars_(datetime.now(), end_date, None)
    events = store.eventsMatchingPredicate_(predicate)
    
    result = []
    for event in events:
        is_in_person = event.location() is not None and "zoom" not in event.location().lower()
        result.append({
            "title": event.title(),
            "start": event.startDate(),
            "end": event.endDate(),
            "location": event.location() or "ONLINE",
            "is_in_person": is_in_person
        })
    
    # Conflict & Buffer Detection
    result.sort(key=lambda x: x['start'])
    for i in range(len(result) - 1):
        if result[i]['end'] > result[i+1]['start']:
            result[i]['conflict'] = True
        elif result[i]['is_in_person'] and result[i+1]['is_in_person']:
            result[i]['needs_travel_buffer'] = True # Trigger Apple Maps routing logic here
            
    return result