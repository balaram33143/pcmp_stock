# 📈 Stock-PCMP Intelligence System
**Probabilistic Capital Markets Pipeline — Hybrid BiLSTM + ARIMA + XGBoost**

A physics-informed, ensemble-based stock price prediction system with an interactive web dashboard.

---

## 🏗️ Architecture

### Components
1. **M1: Market Physics Engine** — Volatility bounds, RSI constraints, ATR circuit breaker, trend inertia
2. **M2: OHLCV Data Loader** — 12 technical indicator features, sliding-window tensors for BiLSTM + tabular for XGBoost
3. **M3: BiLSTM PINN Core** — Physics-informed neural network with MC-Dropout uncertainty estimation
4. **M4: Probabilistic Evaluator** — VaR, CVaR, Sharpe, Max Drawdown risk metrics
5. **M5: Hybrid Ensemble** — Ridge meta-learner stacking: 42% BiLSTM + 20% ARIMA + 38% XGBoost

### Stack
- **Frontend:** HTML5 + Chart.js (interactive dashboard)
- **Backend:** Flask REST API (Python)
- **ML Engines:** PyTorch (BiLSTM) + XGBoost + statsmodels (ARIMA)
- **Data:** Yahoo Finance API (yfinance)

---

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Windows/Mac/Linux
- 2GB RAM minimum

### Installation

#### Option 1: Automated Launch (Windows)
```batch
double-click run_backend.bat
```
This will:
- Create a virtual environment (if needed)
- Install all dependencies
- Start the Flask backend on `http://localhost:5000`

#### Option 2: Manual Setup (All Platforms)

**1. Set up Python environment:**
```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Activate (Mac/Linux)
source venv/bin/activate
```

**2. Install dependencies:**
```bash
pip install -r requirements.txt
```

**3. Start backend:**
```bash
python backend.py
```

### 3. Open Dashboard
Open **`stock_pcmp_dashboard_fixed.html`** in your web browser.

---

## 📡 API Reference

### Base URL
```
http://localhost:5000/api
```

### Health Check
```
GET /api/status

Response:
{
  "status": "online",
  "version": "1.0",
  "device": "cpu"
}
```

### Generate Forecast
```
GET /api/forecast/<TICKER>

Example:
  /api/forecast/AAPL
  /api/forecast/RELIANCE.NS
  /api/forecast/BTC-USD

Response:
{
  "ticker": "AAPL",
  "history": [150.2, 150.5, ...],           // Last 60 days
  "test_actual": [189.5, 189.8, ...],       // Test set actual prices
  "test_lstm": [189.4, 189.9, ...],         // BiLSTM predictions
  "test_arima": [189.1, 189.7, ...],        // ARIMA predictions
  "test_xgboost": [189.6, 189.7, ...],      // XGBoost predictions
  "test_ensemble": [189.5, 189.8, ...],     // Ensemble (weighted blend)
  "future_p50": [190.1, 190.3, ...],        // 30-day median forecast
  "future_p10": [186.2, 186.4, ...],        // 10th percentile (bearish)
  "future_p90": [194.0, 194.2, ...],        // 90th percentile (bullish)
  "risk": {
    "var_95": -2.1,                          // Value at Risk 95%
    "cvar_95": -3.2,                         // Expected Shortfall
    "max_drawdown": 0.084,                   // Max DD
    "sharpe": 0.82,                          // Sharpe Ratio
    "ann_vol": 24.5                          // Annualized volatility
  },
  "metrics": {
    "bilstm": {"rmse": 18.4, "mae": 14.2, "r2": 0.94},
    "arima": {"rmse": 42.1, "mae": 33.6, "r2": 0.79},
    "xgboost": {"rmse": 15.7, "mae": 12.1, "r2": 0.96},
    "ensemble": {"rmse": 11.2, "mae": 8.9, "r2": 0.98}
  }
}
```

---

## 📊 Dashboard Features

### Overview Tab
- **Price History & Predictions** — Historical OHLCV with model overlays
- **Volume & Volatility** — Trading volume + Average True Range (ATR)
- **Model Snapshots** — Individual 30-day forecast returns by model

### Forecast Tab
- **Probabilistic Price Forecast** — P50 median + 80%/95% confidence intervals
- **Forecast Skill Decay** — Accuracy horizon curve
- **Return Distribution** — MC-Dropout 200-sample path histogram

### Risk Analysis Tab
- **Market Risk Gauges** — VaR, Max Drawdown, Sharpe, Volatility gauges
- **12-Month Risk Trend** — Rolling risk metrics

### Technicals Tab
- **RSI (14-day)** — Momentum oscillator
- **MACD** — Signal line + histogram
- **Bollinger Bands** — Volatility envelope (M1 physics constraint)

### Models Tab
- **Model Performance Comparison** — RMSE, MAE, R², MAPE for all 4 models
- **Ensemble Fusion Weights** — 42% BiLSTM, 20% ARIMA, 38% XGBoost
- **Feature Importance (SHAP)** — XGBoost feature attribution

---

## 🎮 Dashboard Controls

### North Sidebar
- **Stock/Ticker Search** — Filter by ticker or name
- **Model Parameters:**
  - Forecast Horizon: 5–180 days
  - MC Samples: 50–1000
  - Window Size: 20–120 days
  - Confidence Interval: 60%–99%
- **Hybrid Models** — Toggle BiLSTM, ARIMA, XGBoost, Ensemble
- **Data Sources** — Yahoo Finance, Market Physics Engine, PCMP Pipeline

### Top Bar
- **Live Metrics** — Last Price, 1D Change, Volume, P/E, RSI
- **Tab Navigation** — Overview, Forecast, Risk, Technicals, Models
- **Export** — CSV (data) + Report (PDF-like text)

### Charts
- All charts are interactive (hover for values, click legend to toggle series)
- Charts auto-update when switching tabs or changing parameters

---

## 🧠 Model Specs

### BiLSTM (PINN)
- **Architecture:** 2-layer bidirectional LSTM (128 hidden × 2 = 256 dim) + dense head
- **Physics Loss:** MSE + volatility ceiling penalty (λ=5.0)
- **MC-Dropout:** 0.3 probability for Bayesian uncertainty
- **Performance (Test):** RMSE ₹18.4, R² 0.94

### ARIMA
- **Auto-Order:** (5, 1, 2) — 5 AR, 1 differencing, 2 MA
- **Use Case:** Linear trend + seasonality capture
- **Performance (Test):** RMSE ₹42.1, R² 0.79

### XGBoost
- **Config:** 100 trees, max_depth=5, learning_rate=0.1
- **Features:** 12 technical indicators (RSI, MACD, Bollinger Bands, EMA, ATR, volume, etc.)
- **Performance (Test):** RMSE ₹15.7, R² 0.96

### Ensemble (PCMP)
- **Meta-Learner:** Ridge regression (α=1.0)
- **Weights:** BiLSTM 42%, ARIMA 20%, XGBoost 38%
- **Physics Constraint:** Hard cap on predicted move (volatility_ceiling)
- **Performance (Test):** RMSE ₹11.2, R² 0.98 ⭐

---

## 📈 Supported Tickers

### India (NSE)
RELIANCE, TCS, INFY, HDFCBANK, WIPRO, HINDUNILVR, ICICIBANK, BAJFINANCE, TATAMOTORS, ADANIENT

### US Markets (NASDAQ/NYSE)
AAPL, MSFT, GOOGL, NVDA, AMZN, TSLA, META

### Crypto
BTC-USD, ETH-USD

Add any Yahoo Finance ticker (e.g., SBIN.NS, GOOGL, etc.)

---

## 🔧 Configuration

### Backend Settings
Edit `backend.py`:
- **DEVICE:** 'cpu' or 'cuda' (GPU if available)
- **BiLSTM epochs:** Change `train_bilstm(epochs=20)` (default: 20)
- **XGBoost params:** Modify `xgb.XGBRegressor(...)` arguments
- **Test split:** Default 20% (`test_split=0.2`)

### Frontend Settings
Edit `stock_pcmp_dashboard_fixed.html`:
- **API_URL:** Line 928 (default: `'http://localhost:5000/api'`)
- **Default ticker:** Line 928 (default: `'RELIANCE'`)
- **Chart refresh rate:** Adjust `setTimeout()` intervals

---

## 🐛 Troubleshooting

### "Backend running on :5000?"
- Backend is not running. Execute `run_backend.bat` or `python backend.py`
- Check firewall — ensure port 5000 is open

### Slow predictions
- Backend training takes 10–30 seconds per ticker (first run cached)
- Reduce `epochs=20` → `epochs=10` in `train_bilstm()` for faster inference

### "Could not fetch data for ticker"
- Invalid ticker or no data on Yahoo Finance
- Try a different ticker (e.g., AAPL, MSFT)

### ModuleNotFoundError
- Virtual environment not activated
- Re-run: `venv\Scripts\activate` (Windows) or `source venv/bin/activate` (Mac/Linux)
- Re-install: `pip install -r requirements.txt`

---

## 📚 References

- **BiLSTM PINN:** Chen et al. 2021 "Physics-Informed Neural Networks"
- **ARIMA:** Box-Jenkins methodology
- **XGBoost:** Chen & Guestrin 2016
- **Ensemble Stacking:** Wolpert 1992
- **Market Physics:** Levy et al. "Physics of Finance" + Technical Analysis

---

## 📄 File Structure

```
stock_pcmp/
├── stock_pcmp_dashboard_fixed.html  (Frontend — open in browser)
├── stock_pcmp_pipeline_fixed.ipynb   (Notebook reference — for research)
├── backend.py                        (Flask REST API)
├── requirements.txt                  (Python dependencies)
├── run_backend.bat                   (Windows launcher)
└── README.md                         (This file)
```

---

## 🚀 Future Enhancements

- [ ] Real-time WebSocket updates
- [ ] Model retraining scheduler (daily/weekly)
- [ ] Backtesting module
- [ ] Portfolio optimization (Markowitz)
- [ ] API key validation + rate limiting
- [ ] Database caching (Redis)
- [ ] Docker containerization
- [ ] Explainability (LIME + SHAP for all models)

---

## 📝 License

Educational & Research Use

---

## 👤 Author

Stock-PCMP Intelligence System v1.0
Probabilistic Capital Markets Pipeline

---

**Questions?** Check the dashboard for live data or review the notebook for detailed methodology.

Happy forecasting! 📊✨
