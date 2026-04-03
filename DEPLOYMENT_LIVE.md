# 🚀 Deploy Stock-PCMP Live — Frontend & Backend

## 📊 Current Status

GitHub shows README by default. To deploy your **live UI** and **ML backend**, follow this guide.

---

## 🌐 OPTION 1: GitHub Pages (Frontend Dashboard - FREE)

### Setup GitHub Pages

1. Go to: https://github.com/balaram33143/pcmp_stock/settings
2. Scroll to **"Pages"** section
3. **Source:** Select `Deploy from a branch`
4. **Branch:** Select `main` / `/ (root)`
5. Click **Save**

GitHub will automatically host your HTML at:
```
https://balaram33143.github.io/pcmp_stock/
```

### Update API URL in Dashboard

The dashboard needs to know where the backend is. Edit the HTML:

**File:** `stock_pcmp_dashboard_fixed.html`

**Find line ~928:**
```javascript
const API_URL = 'http://localhost:5000/api';
```

**Change to your backend URL** (see Options 2-4 below for where to deploy backend)

---

## ⚙️ OPTION 2: Deploy Backend to Heroku (FREE - Easiest)

### Step 1: Create Heroku Account
- Go to: https://www.heroku.com
- Sign up (free account)
- Verify email

### Step 2: Install Heroku CLI
```bash
# Download from https://devcenter.heroku.com/articles/heroku-cli
# Then verify
heroku --version
```

### Step 3: Create Procfile (for Heroku)

Create file: `Procfile` in your project root:
```
web: gunicorn backend:app
```

### Step 4: Update requirements.txt
Add gunicorn to requirements.txt:
```bash
cd "c:\Users\varma\Downloads\stock_pcmp"
echo "gunicorn==21.2.0" >> requirements.txt
```

### Step 5: Deploy to Heroku
```bash
cd "c:\Users\varma\Downloads\stock_pcmp"
heroku login
heroku create pcmp-stock-api
git push heroku main
heroku open
```

Your backend will be at:
```
https://pcmp-stock-api.herokuapp.com/api/forecast/AAPL
```

### Step 6: Update Dashboard API URL
In `stock_pcmp_dashboard_fixed.html` line ~928:
```javascript
const API_URL = 'https://pcmp-stock-api.herokuapp.com/api';
```

Then commit and push:
```bash
git add stock_pcmp_dashboard_fixed.html
git commit -m "Update API URL to Heroku backend"
git push origin main
```

---

## ⚙️ OPTION 3: Deploy Backend to Railway (FREE Alternative)

### Step 1: Go to Railway
- Visit: https://railway.app
- Sign up with GitHub
- Authorize

### Step 2: Create New Project
- Click "New Project"
- Select "Deploy from GitHub repo"
- Select: `balaram33143/pcmp_stock`
- Railway auto-detects it's Python

### Step 3: Add Environment Variables
In Railway dashboard:
- Set: `FLASK_ENV=production`

### Step 4: Get Backend URL
Rail way automatically deploys and gives you:
```
https://your-railway-domain.railway.app/api/forecast/AAPL
```

### Step 5: Update Dashboard
Same as Heroku - update API_URL in HTML

---

## ⚙️ OPTION 4: Deploy Backend to Render (FREE)

### Step 1: Create Render Account
- Go to: https://render.com
- Sign up
- Connect GitHub

### Step 2: Create Web Service
- Click "New +"
- Select "Web Service"
- Select repository: `pcmp_stock`
- Runtime: `Python 3`
- Build command: `pip install -r requirements.txt`
- Start command: `gunicorn backend:app`

### Step 3: Deploy
Click "Create Web Service" - auto-deploys

Your URL:
```
https://pcmp-stock-api.onrender.com
```

---

## 📋 Complete Deployment Checklist

### Frontend (GitHub Pages)
- [ ] Go to Settings → Pages
- [ ] Enable GitHub Pages
- [ ] Repository now live at: `balaram33143.github.io/pcmp_stock/`

### Backend (Pick ONE)
- [ ] **Heroku:** Deploy with `git push heroku main`
- [ ] **Railway:** Auto-deploys from GitHub
- [ ] **Render:** Auto-deploys from GitHub

### Final Step
- [ ] Update `API_URL` in HTML to backend URL
- [ ] Commit and push
- [ ] Test: Open dashboard → Click "Run PCMP Forecast"

---

## 🔄 After Deployment

### Test Everything
1. Open: https://balaram33143.github.io/pcmp_stock/
2. Select stock (e.g., AAPL)
3. Click "Run PCMP Forecast"
4. Watch it fetch data → train models → show predictions

### If Backend Fails
- Check backend logs:
  - Heroku: `heroku logs --tail`
  - Railway: Check "Deployments" tab
  - Render: Check "Logs" tab

---

## 📊 Comparison

| Service | Cost | Setup | Speed | Notes |
|---------|------|-------|-------|-------|
| **GitHub Pages** | FREE | 2 min | Fast | Only frontend (HTML) |
| **Heroku** | FREE (hobby) | 5 min | Slow cold start | Easiest for backend |
| **Railway** | FREE ($5/mo after) | 2 min | Fast | Best free tier |
| **Render** | FREE (sleeping) | 3 min | Very slow wake | Limited free tier |

**Recommendation:** Railway or Render (fastest free tier)

---

## 🚀 Quick Deploy Commands

### GitHub Pages
```bash
# Already started when you enabled it in Settings → Pages
# Just push new changes and it auto-deploys
git push origin main
```

### Heroku
```bash
# One-time setup
echo "web: gunicorn backend:app" > Procfile
echo "gunicorn==21.2.0" >> requirements.txt
heroku login
heroku create pcmp-stock-api
git push heroku main

# Update dashboard HTML to: https://pcmp-stock-api.herokuapp.com/api
# Then:
git add stock_pcmp_dashboard_fixed.html
git commit -m "Update API URL"
git push origin main
```

### Railway
```bash
# Just push - Railway auto-deploys
git push origin main
# Check: https://railway.app dashboard for URL
```

### Render
```bash
# Create web service in Render UI
# Select repository: balaram33143/pcmp_stock
# Auto-deploys
```

---

## 📱 Access Your Live System

After deployment:

**Frontend (Dashboard):**
```
https://balaram33143.github.io/pcmp_stock/
```

**Backend (API):**
```
https://[your-backend-url]/api/status
https://[your-backend-url]/api/forecast/AAPL
```

**Test it:**
```bash
curl https://[your-backend-url]/api/status
```

---

## ✅ Done!

You now have:
- ✅ Frontend dashboard live on GitHub Pages
- ✅ Backend API running on Heroku/Railway/Render
- ✅ Both connected and working together
- ✅ Available 24/7 to anyone with the link

**Share your link:** `https://balaram33143.github.io/pcmp_stock/`

---

## 🆘 Troubleshooting

**"API not responding"**
- Check backend URL in HTML matches deployed URL
- Verify backend logs (Heroku/Railway/Render)
- Check CORS is enabled in backend.py (it is by default)

**"Dashboard loads but no predictions"**
- Open browser console (F12)
- Check Network tab
- Verify API URL is correct

**"Backend sleeps/timed out"**
- Free tiers have suspend/wake delays
- Send ping to keep alive: `curl https://your-url/api/status` every 30 min

---

**Your system is ready to deploy! Pick a backend option and launch!** 🚀
