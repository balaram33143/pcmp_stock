@echo off
REM Stock-PCMP Backend Server Launcher
REM This script sets up and runs the Flask backend

echo.
echo ╔════════════════════════════════════════════╗
echo ║     STOCK-PCMP BACKEND SERVER LAUNCHER     ║
echo ║  Probabilistic Capital Markets Pipeline    ║
echo ╚════════════════════════════════════════════╝
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Python is not installed or not in PATH
    echo Please install Python 3.9+ from https://www.python.org/
    pause
    exit /b 1
)

echo ✓ Python found
echo.

REM Check if venv exists, create if not
if not exist "venv" (
    echo 📦 Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo ❌ Failed to create virtual environment
        pause
        exit /b 1
    )
)

REM Activate virtual environment
echo 🔄 Activating virtual environment...
call venv\Scripts\activate.bat

REM Install/update requirements
echo 📚 Installing dependencies...
pip install --upgrade pip setuptools wheel >nul 2>&1
pip install -r requirements.txt
if errorlevel 1 (
    echo ⚠️  Some packages may have failed to install, but continuing...
)

echo.
echo ╔════════════════════════════════════════════╗
echo ║        STARTING BACKEND SERVER             ║
echo ║      http://localhost:5000                 ║
echo ╚════════════════════════════════════════════╝
echo.
echo 📡 API Endpoints:
echo   • GET  /api/status                 (Health check)
echo   • GET  /api/forecast/^TICKER       (Get forecast for stock)
echo.
echo 🌐 Frontend: Open stock_pcmp_dashboard_fixed.html in your browser
echo.
echo ⏹️  Press Ctrl+C to stop the server
echo.

REM Start the backend
python backend.py

pause
