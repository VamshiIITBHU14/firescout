import SwiftUI

struct SettingsView: View {
    @State var key: String
    let onSave: (String) -> Void
    @EnvironmentObject private var themeStore: ThemeStore

    init(onSave: @escaping (String) -> Void, currentKey: String) {
        self.onSave = onSave
        _key = State(initialValue: currentKey)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.gray.opacity(0.08), .indigo.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Form {
                Section("Credentials") {
                    SecureField("Firecrawl API Key (Bearer fc-…)", text: $key)
                    Button("Save API Key") { onSave(key) }
                        .buttonStyle(.borderedProminent)
                }
                Section("Appearance") {
                    Picker("Theme", selection: $themeStore.theme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.name).tag(theme)
                        }
                    }
                }
                Section(footer: Text("Base URL: https://api.firecrawl.dev").font(.footnote).foregroundStyle(.secondary)) {
                    EmptyView()
                }
            }
        }
        .navigationTitle("Settings")
    }
}
