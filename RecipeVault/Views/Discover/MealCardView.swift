import SwiftUI

struct MealCardView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.3))
                        .overlay(Image(systemName: "photo").foregroundStyle(.gray))
                case .empty:
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.1))
                        .overlay(ProgressView())
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.strMeal)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)

                if let category = meal.strCategory {
                    Text(category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let area = meal.strArea {
                    Text(area)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
