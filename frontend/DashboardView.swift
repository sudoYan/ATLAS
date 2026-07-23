//
//  DashboardView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

struct DashboardView: View {
    var currentContext: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "🌅 Morning Focus: Review briefings and tackle Deep Creative tasks." }
        if hour < 17 { return "⚡ Afternoon Execution: Meetings, buffers, and Administrative tasks." }
        return "🌙 Evening Wind-down: Review open loops and plan tomorrow."
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Dynamic Context Header
                Text(currentContext)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                // Morning Briefing Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily Briefing")
                        .font(.headline)
                    HStack {
                        StatBox(title: "Unread Emails", value: "5", color: .blue)
                        StatBox(title: "Urgent iMessages", value: "2", color: .red)
                        StatBox(title: "Next Event", value: "09:00 AM", color: .purple)
                    }
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Quick Actions
                HStack(spacing: 16) {
                    Button(action: { /* Trigger Backend */ }) {
                        Label("Approve Pending Drafts", systemImage: "paperplane")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: { /* Trigger Backend */ }) {
                        Label("Resolve Schedule Conflicts", systemImage: "exclamationmark.triangle")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(value).font(.title2).fontWeight(.bold).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
