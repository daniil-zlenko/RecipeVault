//
//  RecipeVaultApp.swift
//  RecipeVault
//
//  Created by Daniil Zlenko on 2026-04-08.
//

import SwiftUI
import SwiftData

@main
struct RecipeVaultApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RecipeItem.self)
    }
}
