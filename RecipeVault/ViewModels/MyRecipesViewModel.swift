import Foundation
import Observation
import SwiftData

@Observable
class MyRecipesViewModel {
    var recipes: [RecipeItem] = []

    private let repository = RecipeRepository.shared

    func loadRecipes(context: ModelContext) {
        recipes = repository.fetchSavedRecipes(context: context)
    }

    func deleteRecipe(_ item: RecipeItem, context: ModelContext) {
        repository.deleteRecipe(item, context: context)
        recipes.removeAll { $0.id == item.id }
    }
}
