import SwiftUI
import SwiftData

struct MyRecipesView: View {
    @State private var viewModel = MyRecipesViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var recipeToDelete: RecipeItem? = nil
    @State private var showDeleteAlert = false

    var body: some View {
        Group {
            if viewModel.recipes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No recipes yet.")
                        .font(.headline)
                    Text("Tap + to add one.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(destination: DetailView(recipeId: recipe.id.uuidString, source: "local")) {
                            RecipeCardView(recipe: recipe)
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                recipeToDelete = recipe
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Recipes")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                NavigationLink(destination: AddEditView(recipeId: nil)) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadRecipes(context: modelContext)
        }
        .alert("Delete Recipe", isPresented: $showDeleteAlert, presenting: recipeToDelete) { item in
            Button("Delete", role: .destructive) {
                viewModel.deleteRecipe(item, context: modelContext)
            }
            Button("Cancel", role: .cancel) {}
        } message: { item in
            Text("Are you sure you want to delete \"\(item.title)\"?")
        }
    }
}
