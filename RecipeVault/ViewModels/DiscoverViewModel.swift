import Foundation
import Observation

@Observable
class DiscoverViewModel {
    var meals: [Meal] = []
    var isLoading = false
    var errorMessage: String? = nil
    var searchQuery = ""

    private let repository = RecipeRepository.shared

    func loadRandomMeals() async {
        isLoading = true
        errorMessage = nil

        let results: [Meal] = await withTaskGroup(of: Meal?.self) { group in
            for _ in 0..<10 {
                group.addTask { await MealAPIService.shared.getRandomMeal() }
            }
            var collected: [Meal] = []
            for await meal in group {
                if let meal { collected.append(meal) }
            }
            return collected
        }

        meals = results
        if meals.isEmpty {
            errorMessage = "Could not load meals. Check your connection."
        }
        isLoading = false
    }

    func searchMeals() async {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            await loadRandomMeals()
            return
        }
        isLoading = true
        errorMessage = nil
        meals = await repository.searchMeals(query: query)
        if meals.isEmpty {
            errorMessage = "No results found."
        }
        isLoading = false
    }
}
