import Foundation
import SwiftData

@Model
class RecipeItem {
    var id: UUID
    var title: String
    var desc: String
    var ingredients: String
    var instructions: String
    var imageUrl: String
    var imageData: Data?
    var isFavourite: Bool
    var isCustom: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        desc: String = "",
        ingredients: String = "",
        instructions: String = "",
        imageUrl: String = "",
        imageData: Data? = nil,
        isFavourite: Bool = false,
        isCustom: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.desc = desc
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageUrl = imageUrl
        self.imageData = imageData
        self.isFavourite = isFavourite
        self.isCustom = isCustom
        self.createdAt = createdAt
    }
}
