import SwiftUI
import SwiftData

struct AddEditView: View {
    let recipeId: UUID?

    @State private var viewModel = AddEditViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Title") {
                TextField("Recipe title", text: $viewModel.title)
                if let err = viewModel.titleError {
                    Text(err).font(.caption).foregroundStyle(.red)
                }
            }

            Section("Description") {
                TextField("Short description (optional)", text: $viewModel.desc)
            }

            Section("Ingredients") {
                TextEditor(text: $viewModel.ingredients)
                    .frame(minHeight: 100)
                if let err = viewModel.ingredientsError {
                    Text(err).font(.caption).foregroundStyle(.red)
                }
            }

            Section("Instructions") {
                TextEditor(text: $viewModel.instructions)
                    .frame(minHeight: 150)
            }

            Section("Image URL") {
                TextField("https://...", text: $viewModel.imageUrl)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
            }

            Section {
                Button {
                    if viewModel.saveRecipe(recipeId: recipeId, context: modelContext) {
                        dismiss()
                    }
                } label: {
                    Text(recipeId == nil ? "Add Recipe" : "Update Recipe")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
            }
        }
        .navigationTitle(recipeId == nil ? "Add Recipe" : "Edit Recipe")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            if let id = recipeId {
                viewModel.loadRecipe(id: id, context: modelContext)
            }
        }
    }
}
