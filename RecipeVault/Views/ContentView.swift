import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }

            NavigationStack {
                MyRecipesView()
            }
            .tabItem {
                Label("My Recipes", systemImage: "bookmark")
            }
        }
    }
}
