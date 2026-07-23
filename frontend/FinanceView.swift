//
//  FinanceView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

// MARK: - Data Models
struct StockItem: Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let currentPrice: Double
    let floor: Double
    let ceiling: Double
    let changePercent: Double
}

// MARK: - View
struct FinanceView: View {
    @State private var stocks: [StockItem] = mockStocks()
    @State private var isChecking = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header & Action
                HStack {
                    Text("Portfolio Watcher")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        isChecking = true
                        // TODO: Call backend GET /api/finance/check
                        // Backend will trigger macOS native notifications if thresholds are breached
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isChecking = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .rotationEffect(.degrees(isChecking ? 360 : 0))
                                .animation(.linear(duration: 1), value: isChecking)
                            Text(isChecking ? "Checking Markets..." : "Check Now")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                // Portfolio Summary
                HStack(spacing: 16) {
                    SummaryCard(title: "Active Alerts", value: "\(stocks.filter { $0.currentPrice <= $0.floor || $0.currentPrice >= $0.ceiling }.count)", color: .red)
                    SummaryCard(title: "Trackers", value: "\(stocks.count)", color: .blue)
                }
                .padding(.horizontal)
                
                // Stock List
                VStack(spacing: 12) {
                    ForEach(stocks) { stock in
                        StockCard(stock: stock)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Finance")
    }
    
    // MARK: - Mock Data (Replace with Backend API Call)
    static func mockStocks() -> [StockItem] {
        return [
            StockItem(ticker: "AAPL", name: "Apple Inc.", currentPrice: 178.50, floor: 150.00, ceiling: 200.00, changePercent: 1.2),
            StockItem(ticker: "MSFT", name: "Microsoft Corp.", currentPrice: 310.20, floor: 300.00, ceiling: 450.00, changePercent: -0.5),
            StockItem(ticker: "NVDA", name: "NVIDIA Corp.", currentPrice: 485.00, floor: 400.00, ceiling: 550.00, changePercent: 2.8),
            StockItem(ticker: "TSLA", name: "Tesla Inc.", currentPrice: 242.00, floor: 250.00, ceiling: 350.00, changePercent: -3.4) // Breached floor
        ]
    }
}

// MARK: - Stock Card Component
struct StockCard: View {
    let stock: StockItem
    
    var isBreached: Bool {
        stock.currentPrice <= stock.floor || stock.currentPrice >= stock.ceiling
    }
    
    var breachType: String? {
        if stock.currentPrice <= stock.floor { return "Below Floor" }
        if stock.currentPrice >= stock.ceiling { return "Above Ceiling" }
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Row: Ticker & Price
            HStack {
                VStack(alignment: .leading) {
                    Text(stock.ticker)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(stock.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(format: "$%.2f", stock.currentPrice))
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack(spacing: 4) {
                        Image(systemName: stock.changePercent >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text(String(format: "%.2f%%", stock.changePercent))
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(stock.changePercent >= 0 ? .green : .red)
                }
            }
            
            // Threshold Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(String(format: "$%.0f", stock.floor))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "$%.0f", stock.ceiling))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Custom Progress View showing floor to ceiling range
                GeometryReader { geometry in
                    let range = stock.ceiling - stock.floor
                    let position = min(max((stock.currentPrice - stock.floor) / range, 0), 1)
                    
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        // Safe zone indicator (optional visual flair)
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: geometry.size.width, height: 8)
                            .cornerRadius(4)
                        
                        // Current price indicator
                        Circle()
                            .fill(isBreached ? Color.red : Color.green)
                            .frame(width: 16, height: 16)
                            .shadow(radius: 2)
                            .offset(x: (geometry.size.width - 16) * CGFloat(position))
                    }
                }
                .frame(height: 16)
            }
            
            // Breach Warning Banner
            if let type = breachType {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.shield.fill")
                    Text("\(type): ATLAS will notify you if this persists.")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isBreached ? Color.red.opacity(0.4) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Summary Card Component
struct SummaryCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(value).font(.title2).fontWeight(.bold).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    FinanceView()
        .frame(width: 600, height: 500)
}
