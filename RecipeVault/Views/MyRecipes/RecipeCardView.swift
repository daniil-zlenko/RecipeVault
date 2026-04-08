import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: recipe.imageUrl.isEmpty ? nil : URL(string: recipe.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    placeholder
                case .empty:
                    if recipe.imageUrl.isEmpty {
                        placeholder
                    } else {
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay(ProgressView())
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)

                if !recipe.desc.isEmpty {
                    Text(recipe.desc)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 6) {
                    if recipe.isFavourite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    if recipe.isCustom {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }

            Spacer()
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    private var placeholder: some View {
        Rectangle()
            .foregroundStyle(.gray.opacity(0.2))
            .overlay(Image(systemName: "fork.knife").foregroundStyle(.gray))
    }
}
