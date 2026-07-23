import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess

class AtlasFileHandler(FileSystemEventHandler):
    def on_created(self, event):
        if event.is_directory: return
        filepath = event.src_path
        ext = os.path.splitext(filepath)[1].lower()
        if ext in ['.pdf', '.png', '.jpg', '.docx']:
            filename = os.path.basename(filepath)
            dir_path = os.path.dirname(filepath)
            
            # Lightweight LLM rename
            prompt = f"Rename this file systematically (YYYY-MM-DD_Category_Name{ext}): {filename}. Return ONLY the new filename."
            # new_name = llm.generate(prompt, model="llama3.2") 
            new_name = f"2026-07-24_Receipt_{filename}" # Fallback mock
            
            new_path = os.path.join(dir_path, new_name)
            os.rename(filepath, new_path)
            print(f"📁 ATLAS renamed: {filename} -> {new_name}")

def start_watcher():
    observer = Observer()
    downloads = os.path.expanduser("~/Downloads")
    desktop = os.path.expanduser("~/Desktop")
    observer.schedule(AtlasFileHandler(), downloads, recursive=False)
    observer.schedule(AtlasFileHandler(), desktop, recursive=False)
    observer.start()
    return observer