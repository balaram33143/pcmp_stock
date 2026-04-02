# ⚡ SETUP GUIDE — Stock-PCMP Intelligence System

## 🎯 What You Have

You now have a **complete frontend-backend connection** for the Stock-PCMP pipeline:

- ✅ **Frontend** — Interactive HTML dashboard (`stock_pcmp_dashboard_fixed.html`)
- ✅ **Backend** — Flask REST API server (`backend.py`)
- ✅ **ML Pipeline** — BiLSTM PINN + ARIMA + XGBoost Ensemble
- ✅ **Data Source** — Yahoo Finance API integration
- ✅ **Risk Engine** — Market Physics Engine + Probabilistic Evaluator

---

## 🚀 Getting Started (5 minutes)

### Step 1: Install Python
- **Windows/Mac:** Download from [python.org](https://www.python.org/) (Python 3.9+)
- **Linux:** `sudo apt install python3.9 python3.9-venv`
- Verify: Run `python --version` in terminal

### Step 2: Start Backend Server

**Option A: Windows (Easiest)**
```
Double-click: run_backend.bat
```

**Option B: Mac/Linux**
```bash
chmod +x run_backend.sh
./run_backend.sh
```

**Option C: Manual (Any OS)**
```bash
# Create & activate virtual environment
python -m venv venv
source venv/bin/activate        # Mac/Linux
# OR
venv\Scripts\activate           # Windows

# Install dependencies
pip install -r requirements.txt

# Start server
python backend.py
```

**Expected Output:**
```
🚀 Stock-PCMP Backend Server starting...
📊 Models: BiLSTM (PINN) + ARIMA + XGBoost
🌐 API running on http://localhost:5000
📡 Endpoint: GET /api/forecast/<ticker>
```

### Step 3: Open Dashboard
1. **Open** `stock_pcmp_dashboard_fixed.html` in your web browser
   - Right-click → Open with → Choose browser
   - Or double-click the file
2. You should see the **Stock-PCMP Intelligence dashboard** load with demo data

### Step 4: Run a Forecast
1. **Select a stock** from the sidebar (e.g., RELIANCE, AAPL, MSFT)
2. **Click** "▶ Run PCMP Forecast" button
3. **Wait** 15-30 seconds while models train and predict
4. **View results:**
   - Price predictions overlay on chart
   - Risk metrics (VaR, Sharpe, Max Drawdown)
   - Forecast table with P50/P10/P90 bands
   - Model comparison metrics

---

## 📡 How Communication Works

```
┌──────────────────────┐
│   HTML Dashboard     │  (stock_pcmp_dashboard_fixed.html)
│  • Stock selection   │
│  • Parameter sliders │
│  • Run button        │
└──────────┬───────────┘
           │
           │ API Call: GET /api/forecast/AAPL
           ↓
┌──────────────────────┐
│   Flask Backend      │  (backend.py)
│  • Fetch Yahoo data  │
│  • Train BiLSTM      │
│  • Train ARIMA       │
│  • Train XGBoost     │
│  • Ensemble          │
│  • Compute risk      │
└──────────┬───────────┘
           │
           │ JSON Response: predictions + metrics
           ↓
┌──────────────────────┐
│   Dashboard Display  │
│  • Update charts     │
│  • Show metrics      │
│  • Display forecast  │
└──────────────────────┘
```

---

## 🎮 Using the Dashboard

### Sidebar Controls
- **Stock Search:** Type ticker (e.g., AAPL, TCS, TSLA)
- **Forecast Horizon:** 5-180 days
- **MC Samples:** 50-1000 (more = slower but more stable)
- **Window Size:** 20-120 days of history to use
- **Confidence Interval:** 60%-99%
- **Toggle Models:** Turn BiLSTM/ARIMA/XGBoost on/off

### Top Metrics
Shows current price, change, volume, P/E, RSI for selected stock

### Tabs
1. **Overview** — Price chart + Volume + Model snapshots
2. **Forecast** — Probabilistic forecast with confidence bands
3. **Risk Analysis** — VaR, Sharpe, Max Drawdown gauges
4. **Technicals** — RSI, MACD, Bollinger Bands
5. **Models** — Performance comparison + feature importance

### Export
- **CSV** — Download prediction data
- **Report** — Download text summary

---

## 🔍 Testing the Connection

### Test 1: Check Backend Status
```bash
# Open terminal and run:
curl http://localhost:5000/api/status

# Expected response:
{"status": "online", "version": "1.0", "device": "cpu"}
```

### Test 2: Get a Forecast
```bash
curl http://localhost:5000/api/forecast/AAPL

# Returns: JSON with predictions, risk metrics, model comparisons
```

### Test 3: Try Different Stocks
In dashboard:
- Select "MSFT" → Run → See tech sector predictions
- Select "RELIANCE.NS" → Run → See India market predictions
- Select "BTC-USD" → Run → See crypto predictions

---

## 📊 Understanding the Results

### Price Prediction Chart
- **Gray line** = Historical price
- **Red line** = BiLSTM prediction
- **Blue dashed** = ARIMA prediction
- **Green line** = XGBoost prediction
- **Yellow bold** = Ensemble (final prediction)

### Risk Gauges
- **VaR (95%):** Worst expected daily loss (95% confidence)
- **Max Drawdown:** Deepest peak-to-trough decline
- **Sharpe Ratio:** Risk-adjusted returns (higher = better)
- **Volatility:** Annualized price movement (%)

### Model Metrics
- **RMSE:** Average prediction error (in rupees/dollars)
- **MAE:** Absolute average error
- **R²:** Goodness of fit (1.0 = perfect, 0.0 = random)
- **MAPE:** Percentage error

---

## ⚙️ Configuration

### Change Model Parameters
Edit `backend.py`:

```python
def train_bilstm(dataset, epochs=20):  # ← Change to 10 for faster training
    ...

def train_arima(close_prices, order=(5, 1, 2), ...):  # ← Change ARIMA order
    ...

xgb_model = xgb.XGBRegressor(
    n_estimators=100,        # ← More trees = more accurate but slower
    max_depth=5,             # ← Lower = faster, higher = more complex
    learning_rate=0.1,       # ← Lower = slower learning (more stable)
    ...
)
```

### Change API Port
Edit `backend.py` line at end:
```python
app.run(host='0.0.0.0', port=5000, debug=False)  # ← Change 5000 to desired port
```

Then update HTML `API_URL` to match new port.

---

## 🐛 Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| **"Backend running on :5000?"** | Start backend: `python backend.py` |
| **Port 5000 in use** | Change port in `backend.py`, update HTML |
| **"Could not fetch data"** | Invalid ticker or no data on Yahoo Finance |
| **Slow predictions** | Reduce BiLSTM `epochs=10`, XGBoost `n_estimators=50` |
| **ModuleNotFoundError** | Activate venv: `source venv/bin/activate` (Mac/Linux) or `venv\Scripts\activate` (Windows) |
| **venv not found** | Create it: `python -m venv venv` |
| **ImportError: torch/xgboost** | Reinstall: `pip install -r requirements.txt` |

---

## 📈 Production Deployment

For online deployment, replace localhost with:

```javascript
// In HTML file (search for API_URL):
const API_URL = 'https://your-domain.com/api';
```

Then use:
- **Docker** for containerization
- **Nginx** or **Apache** as reverse proxy
- **Gunicorn** for production WSGI server
- **Redis** for caching predictions
- **PostgreSQL** for historical data storage

See `README.md` for advanced setup.

---

## ✅ You're Ready!

The frontend and backend are now **fully connected**. 

**Next steps:**
1. ✅ Start `backend.py`
2. ✅ Open `stock_pcmp_dashboard_fixed.html`
3. ✅ Select a stock and click "Run PCMP Forecast"
4. ✅ Explore predictions, risk metrics, and model comparisons

---

## 📞 Support

**If something doesn't work:**
1. Check terminal for error messages
2. Verify Python version: `python --version`
3. Verify venv activated (should see `(venv)` in terminal)
4. Check port 5000 is open: `netstat -an | grep 5000`
5. Restart everything: Close terminal, run setup again

**For more info:** Read `README.md` for detailed documentation.

---

**Happy forecasting! 📊✨**
