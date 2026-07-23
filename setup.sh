#!/bin/bash
echo "🚀 Setting up ATLAS Local Environment..."

# 1. Create local storage directories
mkdir -p ~/.atlas/{vector_db,logs,projects}

# 2. Setup Python Virtual Environment
python3 -m venv venv
source venv/bin/activate

# 3. Install Dependencies
pip install --upgrade pip
pip install fastapi uvicorn httpx pydantic yfinance watchdog lancedb pandas pyobjc sentence-transformers

# 4. Check Ollama
if ! command -v ollama &> /dev/null; then
    echo "⚠️ Ollama not found. Please install from https://ollama.com"
else
    ollama pull qwen2.5:7b
    ollama pull llama3.2 # Lightweight model for file naming
fi

echo "Setup complete. Run 'source venv/bin/activate && uvicorn backend.main:app --reload'"