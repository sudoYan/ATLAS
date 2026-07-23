//
//  TasksView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let cognitiveLoad: String
    let project: String
    let completion: Double
    let sourceURL: String? // e.g., "message://<id>"
}

struct TasksView: View {
    let tasks = [
        TaskItem(title: "Reply to Q3 Budget Inquiry", cognitiveLoad: "Administrative", project: "Finance", completion: 0.0, sourceURL: "message://<abc123>"),
        TaskItem(title: "Draft Q4 Product Roadmap", cognitiveLoad: "Deep Creative", project: "Product", completion: 0.3, sourceURL: nil),
        TaskItem(title: "Approve Team PTO Requests", cognitiveLoad: "Low Effort", project: "HR", completion: 0.8, sourceURL: nil)
    ]
    
    var body: some View {
        List(tasks) { task in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(task.title).font(.headline)
                        Spacer()
                        CognitiveLoadBadge(load: task.cognitiveLoad)
                    }
                    Text(task.project).font(.subheadline).foregroundColor(.secondary)
                    
                    ProgressView(value: task.completion)
                        .progressViewStyle(.linear)
                        .tint(task.cognitiveLoad == "Deep Creative" ? .purple : .blue)
                }
                
                Spacer()
                
                if let url = task.sourceURL, let deepLink = URL(string: url) {
                    Button(action: { NSWorkspace.shared.open(deepLink) }) {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    .help("Open Source Message")
                }
            }
            .padding(.vertical, 8)
        }
        .listStyle(.inset)
    }
}

struct CognitiveLoadBadge: View {
    let load: String
    var color: Color {
        switch load {
        case "Deep Creative": return .purple
        case "Administrative": return .blue
        case "Low Effort": return .green
        default: return .gray
        }
    }
    var body: some View {
        Text(load)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(6)
    }
}
