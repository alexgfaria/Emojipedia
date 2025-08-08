//
//  blissAppsTechChallengeApp.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

import SwiftUI

@main
struct blissAppsTechChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
