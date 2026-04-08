import SwiftUI
import SwiftData

struct DetailView: View {
    let recipeId: String
    let source: String

    @State private var viewModel = DetailViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .frame(maxWidth: .infinity)
            } else if source == "api", let meal = viewModel.meal {
                APIDetailContent(meal: meal, isSaved: viewModel.isSaved) {
                    viewModel.saveToMyRecipes(context: modelContext)
                }
            } else if source == "local", let recipe = viewModel.recipe {
                LocalDetailContent(recipe: recipe)
            }
        }
        .navigationTitle(navTitle)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            if source == "local", let recipe = viewModel.recipe {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: AddEditView(recipeId: recipe.id)) {
                        Text("Edit")
                    }
                }
            }
        }
        .task {
            if source == "api" {
                await viewModel.loadFromAPI(mealId: recipeId)
            } else if let uuid = UUID(uuidString: recipeId) {
                viewModel.loadFromLocal(recipeId: uuid, context: modelContext)
            }
        }
    }

    private var navTitle: String {
        source == "api" ? (viewModel.meal?.strMeal ?? "Recipe") : (viewModel.recipe?.title ?? "Recipe")
    }
}

// MARK: - API Detail

private struct APIDetailContent: View {
    let meal: Meal
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity).frame(height: 280).clipped()
                case .failure:
                    imagePlaceholder
                case .empty:
                    Rectangle().foregroundStyle(.gray.opacity(0.1)).frame(height: 280)
                        .overlay(ProgressView())
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(meal.strMeal)
                    .font(.title2).fontWeight(.bold)

                HStack(spacing: 12) {
                    if let cat = meal.strCategory {
                        Label(cat, systemImage: "tag").font(.subheadline).foregroundStyle(.secondary)
                    }
                    if let area = meal.strArea {
                        Label(area, systemImage: "globe").font(.subheadline).foregroundStyle(.secondary)
                    }
                }

                Button(action: onSave) {
                    Label(isSaved ? "Saved ✓" : "Save to My Recipes",
                          systemImage: isSaved ? "checkmark.circle.fill" : "plus.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSaved)

                let ingredients = meal.toIngredientString()
                if !ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients").font(.headline)
                        Text(ingredients).font(.body)
                    }
                }

                if let instructions = meal.strInstructions, !instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions").font(.headline)
                        Text(instructions).font(.body)
                    }
                }
            }
            .padding(16)
        }
    }

    private var imagePlaceholder: some View {
        Rectangle().foregroundStyle(.gray.opacity(0.3)).frame(height: 280)
            .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.gray))
    }
}

// MARK: - Local Detail

private struct LocalDetailContent: View {
    let recipe: RecipeItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: recipe.imageUrl.isEmpty ? nil : URL(string: recipe.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity).frame(height: 280).clipped()
                case .failure:
                    imagePlaceholder
                case .empty:
                    if recipe.imageUrl.isEmpty {
                        imagePlaceholder
                    } else {
                        Rectangle().foregroundStyle(.gray.opacity(0.1)).frame(height: 280)
                            .overlay(ProgressView())
                    }
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.title)
                    .font(.title2).fontWeight(.bold)

                if !recipe.desc.isEmpty {
                    Text(recipe.desc).font(.subheadline).foregroundStyle(.secondary)
                }

                if !recipe.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients").font(.headline)
                        Text(recipe.ingredients).font(.body)
                    }
                }

                if !recipe.instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions").font(.headline)
                        Text(recipe.instructions).font(.body)
                    }
                }
            }
            .padding(16)
        }
    }

    private var imagePlaceholder: some View {
        Rectangle().foregroundStyle(.orange.opacity(0.15)).frame(height: 280)
            .overlay(Image(systemName: "fork.knife").font(.largeTitle).foregroundStyle(.orange))
    }
}
