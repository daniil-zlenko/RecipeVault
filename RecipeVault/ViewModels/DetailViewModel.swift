import Foundation
import Observation
import SwiftData

@Observable
class DetailViewModel {
    var meal: Meal? = nil
    var recipe: RecipeItem? = nil
    var isLoading = false
    var errorMessage: String? = nil
    var isSaved = false

    private let repository = RecipeRepository.shared

    func loadFromAPI(mealId: String) async {
        isLoading = true
        errorMessage = nil
        meal = await repository.getMealById(id: mealId)
        if meal == nil { errorMessage = "Could not load recipe." }
        isLoading = false
    }

    func loadFromLocal(recipeId: UUID, context: ModelContext) {
        isLoading = true
        errorMessage = nil
        recipe = repository.fetchRecipeById(id: recipeId, context: context)
        if recipe == nil { errorMessage = "Recipe not found." }
        isLoading = false
    }

    func saveToMyRecipes(context: ModelContext) {
        guard let meal, !isSaved else { return }
        let item = meal.toRecipeItem()
        repository.saveRecipe(item, context: context)
        isSaved = true
    }
}
