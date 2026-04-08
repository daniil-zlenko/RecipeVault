import Foundation

struct MealResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
}

extension Meal {
    func toIngredientString() -> String {
        let raw = [
            strIngredient1, strIngredient2, strIngredient3,
            strIngredient4, strIngredient5, strIngredient6,
            strIngredient7, strIngredient8, strIngredient9,
            strIngredient10
        ]
        return raw
            .compactMap { $0 }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }

    func toRecipeItem() -> RecipeItem {
        RecipeItem(
            title: strMeal,
            desc: [strCategory, strArea]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: " • "),
            ingredients: toIngredientString(),
            instructions: strInstructions ?? "",
            imageUrl: strMealThumb ?? "",
            isFavourite: true,
            isCustom: false
        )
    }
}
