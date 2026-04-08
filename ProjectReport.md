# RecipeVault — Project Report

**Course:** Mobile Application Development
**Platform:** Native iOS (Swift, SwiftUI, SwiftData)
**Developer:** Daniil Zlenko

---

## 1. App Description

RecipeVault is a native iOS recipe manager that lets users discover meals from a live public API and build a personal collection of saved and custom recipes. The app targets home cooks and food enthusiasts who want a single place to browse recipe ideas online and keep track of their own creations offline.

The app is built entirely with Apple's modern frameworks — SwiftUI for the interface, SwiftData for local persistence, and URLSession for networking — with no third-party dependencies.

---

## 2. Feature Explanation

### Discover Tab
Users open the app to a curated feed of 10 randomly fetched meals loaded concurrently from TheMealDB public API. A search bar at the top allows querying by name. While data is loading, a progress indicator is shown. If the network is unavailable or the query returns no results, a clear message is displayed instead of a blank screen.

### My Recipes Tab
Displays the user's personal recipe collection — both recipes saved from the API and custom recipes created manually. The list supports swipe-to-delete with a confirmation alert to prevent accidental removal. An empty state with instructional text is shown when no recipes exist yet. A "+" toolbar button navigates to the Add screen.

### Detail Screen
Handles two distinct contexts via a `source` parameter:
- **API source:** Fetches full meal data by ID, displays image, category, area, ingredients, and instructions. A "Save to My Recipes" button persists the meal to local storage; the button changes to "Saved ✓" and disables after saving.
- **Local source:** Loads a saved RecipeItem from SwiftData and displays its contents. An "Edit" toolbar button navigates to the edit form pre-filled with existing data.

### Add / Edit Screen
A form-based screen used for both creating new recipes and editing existing ones. Fields include title, description, ingredients (multiline), instructions (multiline), and an image URL. Validation runs on submit: the title must be at least 3 characters and ingredients cannot be empty. Inline red error messages appear below the relevant fields. On success the view dismisses automatically.

---

## 3. Architecture Overview

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
SwiftUI Views  →  @Observable ViewModels  →  RecipeRepository  →  SwiftData + URLSession
```

### Layers

| Layer | Responsibility |
|---|---|
| **Models** | `RecipeItem` (SwiftData `@Model`), `Meal` / `MealResponse` (Codable API structs) |
| **Data** | `MealAPIService` — all URLSession calls; `RecipeRepository` — single access point for both API and SwiftData |
| **ViewModels** | `@Observable` classes holding UI state; one per screen |
| **Views** | Pure SwiftUI; no business logic; receive injected ModelContext via `@Environment` |

### Key Technical Decisions
- **`@Observable` (iOS 17)** replaces the older `@ObservableObject` / `@Published` pattern for lighter, more efficient observation.
- **SwiftData** is used instead of CoreData for its Swift-native API and automatic schema migration.
- **`async/await` with `TaskGroup`** loads 10 random meals concurrently on the Discover screen without blocking the main thread.
- **No third-party libraries** — the project relies entirely on Apple frameworks, which eliminates dependency management overhead and ensures long-term compatibility.

### File Structure
```
RecipeVault/
├── Models/          RecipeItem.swift, MealModels.swift
├── Data/            MealAPIService.swift, RecipeRepository.swift
├── ViewModels/      DiscoverViewModel, MyRecipesViewModel,
│                    DetailViewModel, AddEditViewModel
└── Views/
    ├── Discover/    DiscoverView, MealCardView
    ├── MyRecipes/   MyRecipesView, RecipeCardView
    ├── Detail/      DetailView
    └── AddEdit/     AddEditView
```

---

## 4. Screenshots

| Screen | Description |
|---|---|
| Discover | Grid of meal cards with thumbnail, name, and category fetched from API |
| Discover (Search) | Search results for a query with loading and empty states |
| My Recipes | Personal list with swipe-to-delete and empty state placeholder |
| Detail (API) | Full meal view with ingredients, instructions, and Save button |
| Detail (Local) | Saved recipe view with Edit toolbar button |
| Add / Edit | Form with inline validation error messages |

*(Screenshots taken from iPhone 16 Simulator, iOS 18)*

---

## 5. Team Member Contributions

| Member | Role | Contributions |
|---|---|---|
| Daniil Zlenko | Full-stack (sole developer) | Architecture design, all SwiftData models, API service layer, repository pattern, all four ViewModels, all UI screens, navigation, form validation, error and loading states, Git version control |

---

## 6. Challenges and Solutions

**Challenge 1 — Concurrent API fetching**
Loading 10 random meals sequentially would be slow. Swift's structured concurrency (`withTaskGroup`) was used to dispatch all 10 requests in parallel, collecting results as they arrive. This reduced perceived load time significantly.

**Challenge 2 — Unified Detail screen for two data sources**
The Detail screen needed to handle both live API data and locally stored records. This was solved by passing a `source` string parameter alongside the ID, and routing the ViewModel to either fetch from the API or query SwiftData accordingly. Two private subviews (`APIDetailContent`, `LocalDetailContent`) keep the layout code clean and separated.

**Challenge 3 — macOS compatibility during development**
Several iOS-exclusive modifiers (`.topBarTrailing`, `.navigationBarTitleDisplayMode`, `.keyboardType`, `.textInputAutocapitalization`) caused build failures when the Xcode destination was set to "My Mac." These were resolved using `#if os(iOS)` conditional compilation blocks, making the project buildable on both platforms.

**Challenge 4 — SwiftData predicate syntax**
SwiftData's `#Predicate` macro uses a strict subset of Swift expressions. Compound predicates with `||` required careful structuring to satisfy the macro's constraints, particularly in the repository's `fetchSavedRecipes` method.
