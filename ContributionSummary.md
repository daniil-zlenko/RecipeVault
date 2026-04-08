# Contribution Summary — RecipeVault

**App:** RecipeVault
**Platform:** Native iOS (Swift, SwiftUI, SwiftData)

---

## Team Members & Roles

| Member | Role |
|---|---|
| Daniil Zlenko | Sole Developer |

---

## Daniil Zlenko — Full Contribution

**Architecture & Planning**
- Designed the overall MVVM architecture
- Defined the data flow between Views, ViewModels, Repository, and API/SwiftData layers
- Set up the Xcode project and Git repository

**Data Layer**
- Implemented `RecipeItem` SwiftData model
- Defined `Meal` and `MealResponse` Codable structs for API parsing
- Built `MealAPIService` with all three API endpoints using URLSession async/await
- Built `RecipeRepository` as a unified access point for both local and remote data

**ViewModels**
- `DiscoverViewModel` — search, random meal loading, error and loading state management
- `MyRecipesViewModel` — fetching and deleting saved recipes
- `DetailViewModel` — dual-source loading (API vs. local), save-to-collection logic
- `AddEditViewModel` — field state, form validation, create and update logic

**UI & Navigation**
- `ContentView` — TabView root with two NavigationStacks
- `DiscoverView` — search bar, async meal feed, loading/empty/error states
- `MealCardView` — card component with AsyncImage, name, category
- `MyRecipesView` — list with swipe-to-delete, empty state, toolbar add button
- `RecipeCardView` — card component with image, title, description, badges
- `DetailView` — unified detail screen handling both API and local sources
- `AddEditView` — form screen with inline validation for create and edit

**Testing & Debugging**
- Resolved iOS-only API compatibility issues for macOS builds
- Tested all CRUD flows and navigation paths on iPhone simulator
- Verified API error handling and offline fallback behaviour

---

*All code written and committed by Daniil Zlenko.*
