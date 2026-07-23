//
//  ContentView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "Dashboard"
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedTab: $selectedTab)
        } detail: {
            Group {
                switch selectedTab {
                case "Dashboard": DashboardView()
                case "Tasks": TasksView()
                case "Inbox": CommunicationsView()
                case "Calendar": CalendarView()
                case "Finance": FinanceView()
                default: DashboardView()
                }
            }
            .navigationTitle(selectedTab)
        }
    }
}

struct SidebarView: View {
    @Binding var selectedTab: String
    let items = ["Dashboard", "Tasks", "Inbox", "Calendar", "Finance", "Settings"]
    
    var body: some View {
        List(items, id: \.self, selection: $selectedTab) { item in
            Label(item, systemImage: icon(for: item))
                .font(.system(size: 14, weight: .medium))
                .padding(.vertical, 4)
        }
        .listStyle(.sidebar)
        .padding(.top, 20)
    }
    
    func icon(for item: String) -> String {
        switch item {
        case "Dashboard": return "gauge.medium"
        case "Tasks": return "checklist"
        case "Inbox": return "envelope"
        case "Calendar": return "calendar"
        case "Finance": return "chart.line.uptrend.xyaxis"
        case "Settings": return "gearshape"
        default: return "circle"
        }
    }
}
