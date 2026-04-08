import SwiftUI

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                TextField("Search meals...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { Task { await viewModel.searchMeals() } }

                Button("Search") {
                    Task { await viewModel.searchMeals() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(16)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if let error = viewModel.errorMessage {
                Spacer()
                Text(error)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(16)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.meals, id: \.idMeal) { meal in
                            NavigationLink(destination: DetailView(recipeId: meal.idMeal, source: "api")) {
                                MealCardView(meal: meal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle("Discover")
        .task {
            if viewModel.meals.isEmpty {
                await viewModel.loadRandomMeals()
            }
        }
    }
}
