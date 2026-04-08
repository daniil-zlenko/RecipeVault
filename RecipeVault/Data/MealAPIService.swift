import Foundation

class MealAPIService {
    static let shared = MealAPIService()
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"

    private init() {}

    func searchMeals(query: String) async -> [Meal] {
        guard
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "\(baseURL)/search.php?s=\(encoded)")
        else { return [] }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MealResponse.self, from: data)
            return response.meals ?? []
        } catch {
            return []
        }
    }

    func getRandomMeal() async -> Meal? {
        guard let url = URL(string: "\(baseURL)/random.php") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MealResponse.self, from: data)
            return response.meals?.first
        } catch {
            return nil
        }
    }

    func getMealById(id: String) async -> Meal? {
        guard let url = URL(string: "\(baseURL)/lookup.php?i=\(id)") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MealResponse.self, from: data)
            return response.meals?.first
        } catch {
            return nil
        }
    }
}
