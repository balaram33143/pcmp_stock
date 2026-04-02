#!/bin/bash
# Stock-PCMP Backend Server Launcher (macOS/Linux)

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║     STOCK-PCMP BACKEND SERVER LAUNCHER     ║"
echo "║  Probabilistic Capital Markets Pipeline    ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ ERROR: Python 3 is not installed"
    echo "Please install Python 3.9+ from https://www.python.org/"
    exit 1
fi

echo "✓ Python found"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create virtual environment"
        exit 1
    fi
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install/update requirements
echo "📚 Installing dependencies (this may take a few minutes)..."
pip install --upgrade pip setuptools wheel > /dev/null 2>&1
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "⚠️  Some packages may have failed to install, but continuing..."
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║        STARTING BACKEND SERVER             ║"
echo "║      http://localhost:5000                 ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "📡 API Endpoints:"
echo "   • GET  /api/status                 (Health check)"
echo "   • GET  /api/forecast/TICKER        (Get forecast for stock)"
echo ""
echo "🌐 Frontend: Open stock_pcmp_dashboard_fixed.html in your browser"
echo ""
echo "⏹️  Press Ctrl+C to stop the server"
echo ""

# Start the backend
python backend.py
