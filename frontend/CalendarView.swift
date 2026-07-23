//
//  CalendarView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

// MARK: - Data Models
struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let startTime: Date
    let endTime: Date
    let location: String
    let isOnline: Bool
    let hasConflict: Bool
    let needsTravelBuffer: Bool
}

// MARK: - View
struct CalendarView: View {
    @State private var events: [CalendarEvent] = mockEvents()
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Next 48 Hours")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        isRefreshing = true
                        // TODO: Call backend GET /api/calendar/upcoming
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isRefreshing = false
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(.linear(duration: 1), value: isRefreshing)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Timeline List
                VStack(spacing: 16) {
                    ForEach(events) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Calendar & Buffers")
    }
    
    // MARK: - Mock Data (Replace with Backend API Call)
    static func mockEvents() -> [CalendarEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            CalendarEvent(
                title: "Deep Work: Q4 Roadmap",
                startTime: now,
                endTime: calendar.date(byAdding: .hour, value: 2, to: now)!,
                location: "ONLINE",
                isOnline: true,
                hasConflict: false,
                needsTravelBuffer: false
            ),
            CalendarEvent(
                title: "Lunch with Sarah (Investor)",
                startTime: calendar.date(byAdding: .hour, value: 3, to: now)!,
                endTime: calendar.date(byAdding: .hour, value: 4, to: now)!,
                location: "The French Laundry, Yountville",
                isOnline: false,
                hasConflict: false,
                needsTravelBuffer: true // Triggers buffer warning
            ),
            CalendarEvent(
                title: "Engineering Sync",
                startTime: calendar.date(byAdding: .hour, value: 4, to: now)!, // Overlaps with previous end time
                endTime: calendar.date(byAdding: .hour, value: 5, to: now)!,
                location: "Zoom",
                isOnline: true,
                hasConflict: true, // Flagged by backend
                needsTravelBuffer: false
            )
        ]
    }
}

// MARK: - Event Card Component
struct EventCard: View {
    let event: CalendarEvent
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Time Column
            VStack(alignment: .trailing, spacing: 4) {
                Text(timeFormatter.string(from: event.startTime))
                    .font(.headline)
                    .foregroundColor(event.hasConflict ? .red : .primary)
                Text(timeFormatter.string(from: event.endTime))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)
            
            // Divider
            Rectangle()
                .fill(event.hasConflict ? Color.red : (event.needsTravelBuffer ? Color.orange : Color.blue))
                .frame(width: 3)
                .cornerRadius(2)
            
            // Content Column
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(event.title)
                        .font(.headline)
                    if event.hasConflict {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }
                
                HStack(spacing: 6) {
                    Image(systemName: event.isOnline ? "video.fill" : "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text(event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Travel Buffer Warning
                if event.needsTravelBuffer {
                    HStack(spacing: 6) {
                        Image(systemName: "car.fill")
                        Text("ATLAS suggests adding a 45-min travel buffer before this event.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
                
                // Conflict Resolution Action
                if event.hasConflict {
                    Button(action: {
                        // TODO: Call backend to propose reschedule or send decline
                        print("Resolving conflict for: \(event.title)")
                    }) {
                        Label("Resolve Conflict", systemImage: "wand.and.stars")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.top, 4)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(color: event.hasConflict ? Color.red.opacity(0.2) : Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(event.hasConflict ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    CalendarView()
        .frame(width: 600, height: 500)
}
