//
//  CommunicationsView.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

struct CommunicationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("AI-Suggested Drafts")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Re: Project Atlas Timeline").font(.headline)
                Text("Hi John, I've reviewed the timeline. The backend integration will take 3 days, pushing the delivery to Friday. Let me know if we need to adjust scope.").font(.body)
                    .padding()
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(8)
                
                HStack {
                    Button("Edit in Mail") {
                        // Call backend /api/communications/draft
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Regenerate") {
                        // Call backend LLM
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
}
