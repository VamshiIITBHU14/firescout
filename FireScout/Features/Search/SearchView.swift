import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel
    @EnvironmentObject private var themeStore: ThemeStore
    var body: some View {
        ZStack {
            themeStore.theme.gradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    HStack {
                        TextField("Query (supports operators like site:, inurl:)", text: $vm.query)
                            .textFieldStyle(.roundedBorder)
                        Button("Search") { Task { await vm.run() } }
                            .buttonStyle(.borderedProminent)
                    }
                    if vm.isLoading { ProgressView("Searching…") }
                    if let e = vm.error { Text(e).foregroundStyle(.red) }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

                List(vm.results) { item in
                    NavigationLink(destination: MarkdownView(markdown: item.markdown ?? "# No markdown")) {
                        VStack(alignment: .leading) {
                            Text(item.title ?? item.url).font(.headline)
                            Text(item.url).font(.footnote).foregroundStyle(.secondary)
                            if let d = item.description { Text(d).font(.subheadline).foregroundStyle(.secondary) }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .padding()
        }
        .navigationTitle("Search")
    }
}
