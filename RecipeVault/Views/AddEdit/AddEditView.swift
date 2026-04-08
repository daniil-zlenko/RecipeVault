import SwiftUI
import SwiftData
import PhotosUI

struct AddEditView: View {
    let recipeId: UUID?

    @State private var viewModel = AddEditViewModel()
    @State private var selectedPhoto: PhotosPickerItem? = nil
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

            Section("Image") {
                if let data = viewModel.selectedImageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .listRowInsets(EdgeInsets())
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Choose from Photos", systemImage: "photo")
                }
                .onChange(of: selectedPhoto) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.selectedImageData = data
                            viewModel.imageUrl = ""
                        }
                    }
                }

                TextField("or paste image URL", text: $viewModel.imageUrl)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
                    .onChange(of: viewModel.imageUrl) { _, newValue in
                        if !newValue.isEmpty {
                            viewModel.selectedImageData = nil
                            selectedPhoto = nil
                        }
                    }
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
