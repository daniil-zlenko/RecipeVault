import Foundation
import Observation
import SwiftData

@Observable
class AddEditViewModel {
    var title = ""
    var desc = ""
    var ingredients = ""
    var instructions = ""
    var imageUrl = ""
    var selectedImageData: Data? = nil

    var titleError: String? = nil
    var ingredientsError: String? = nil

    private let repository = RecipeRepository.shared

    func loadRecipe(id: UUID, context: ModelContext) {
        guard let item = repository.fetchRecipeById(id: id, context: context) else { return }
        title = item.title
        desc = item.desc
        ingredients = item.ingredients
        instructions = item.instructions
        imageUrl = item.imageUrl
        selectedImageData = item.imageData
    }

    private func validate() -> Bool {
        var valid = true

        if title.trimmingCharacters(in: .whitespaces).count < 3 {
            titleError = "Title must be at least 3 characters."
            valid = false
        } else {
            titleError = nil
        }

        if ingredients.trimmingCharacters(in: .whitespaces).isEmpty {
            ingredientsError = "Ingredients cannot be empty."
            valid = false
        } else {
            ingredientsError = nil
        }

        return valid
    }

    func saveRecipe(recipeId: UUID?, context: ModelContext) -> Bool {
        guard validate() else { return false }

        if let id = recipeId, let existing = repository.fetchRecipeById(id: id, context: context) {
            existing.title = title
            existing.desc = desc
            existing.ingredients = ingredients
            existing.instructions = instructions
            existing.imageUrl = imageUrl
            existing.imageData = selectedImageData
            repository.updateRecipe(context: context)
        } else {
            let item = RecipeItem(
                title: title,
                desc: desc,
                ingredients: ingredients,
                instructions: instructions,
                imageUrl: imageUrl,
                imageData: selectedImageData,
                isFavourite: false,
                isCustom: true
            )
            repository.saveRecipe(item, context: context)
        }

        return true
    }
}
