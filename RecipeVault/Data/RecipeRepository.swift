import Foundation
import SwiftData

class RecipeRepository {
    static let shared = RecipeRepository()
    private let api = MealAPIService.shared

    private init() {}

    // MARK: - API

    func searchMeals(query: String) async -> [Meal] {
        await api.searchMeals(query: query)
    }

    func getRandomMeal() async -> Meal? {
        await api.getRandomMeal()
    }

    func getMealById(id: String) async -> Meal? {
        await api.getMealById(id: id)
    }

    // MARK: - SwiftData

    func fetchSavedRecipes(context: ModelContext) -> [RecipeItem] {
        let descriptor = FetchDescriptor<RecipeItem>(
            predicate: #Predicate { $0.isCustom == true || $0.isFavourite == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchRecipeById(id: UUID, context: ModelContext) -> RecipeItem? {
        let descriptor = FetchDescriptor<RecipeItem>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    func saveRecipe(_ item: RecipeItem, context: ModelContext) {
        context.insert(item)
        try? context.save()
    }

    func deleteRecipe(_ item: RecipeItem, context: ModelContext) {
        context.delete(item)
        try? context.save()
    }

    func updateRecipe(context: ModelContext) {
        try? context.save()
    }
}
