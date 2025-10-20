//
//  FireScoutApp.swift
//  FireScout
//
//  Created by Vamshi Krishna on 20/10/25.
//


import SwiftUI

@main
struct FireScoutApp: App {
    @StateObject private var container = AppContainer()
    @StateObject private var themeStore = ThemeStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    MapView(vm: MapViewModel(api: container.client)) { url in
                        // For a deeper demo, wire this to navigate to Scrape tab and prefill URL.
                    }
                    .padding()
                }.tabItem { Label("Map", systemImage: "map") }

                NavigationStack {
                    ScrapeView(vm: ScrapeViewModel(api: container.client))
                        .padding()
                }.tabItem { Label("Scrape", systemImage: "doc.plaintext") }

                NavigationStack {
                    ExtractView(vm: ExtractViewModel(api: container.client))
                        .padding()
                }.tabItem { Label("Extract", systemImage: "square.and.arrow.down.on.square") }

                NavigationStack {
                    SearchView(vm: SearchViewModel(api: container.client))
                        .padding()
                }.tabItem { Label("Search", systemImage: "magnifyingglass") }

                NavigationStack {
                    SettingsView(onSave: { key in container.updateAPIKey(key) },
                                 currentKey: container.secretStore.apiKey ?? "")
                        .padding()
                }.tabItem { Label("Settings", systemImage: "gear") }
            }
            .tint(themeStore.theme.accent)
            .environmentObject(themeStore)
        }
    }
}

