//
//  Item.swift
//  RecipeVault
//
//  Created by Daniil Zlenko on 2026-04-08.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
