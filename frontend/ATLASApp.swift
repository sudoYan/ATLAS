//
//  ATLASApp.swift
//  
//
//  Created by Aryan Dixit on 7/23/26.
//

import SwiftUI

@main
struct ATLASApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1000, minHeight: 700)
                .navigationTitle("ATLAS")
        }
        .windowStyle(.hiddenTitleBar) // Sleek, minimalist look
    }
}
