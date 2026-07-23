import yfinance as yf
import subprocess

def check_portfolio(tickers_thresholds: dict):
    alerts = []
    for ticker, (floor, ceiling) in tickers_thresholds.items():
        data = yf.Ticker(ticker).history(period="1d")
        if not data.empty:
            current_price = float(data['Close'].iloc[-1])
            if current_price <= floor:
                alerts.append(f"🚨 {ticker} dropped to ${current_price:.2f} (Floor: ${floor})")
            elif current_price >= ceiling:
                alerts.append(f"📈 {ticker} rose to ${current_price:.2f} (Ceiling: ${ceiling})")
    
    for alert in alerts:
        subprocess.run(['osascript', '-e', f'display notification "{alert}" with title "ATLAS Finance Watcher" sound name "Ping"'])
    return alerts