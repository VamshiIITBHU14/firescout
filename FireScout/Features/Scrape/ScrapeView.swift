import SwiftUI

struct ScrapeView: View {
    @StateObject var vm: ScrapeViewModel
    @EnvironmentObject private var themeStore: ThemeStore
    var body: some View {
        ZStack {
            themeStore.theme.gradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    HStack {
                        TextField("Paste a URL…", text: $vm.url)
                            .textFieldStyle(.roundedBorder)
                        Button("Scrape") { Task { await vm.scrape() } }
                            .buttonStyle(.borderedProminent)
                    }
                    if vm.isLoading { ProgressView("Scraping…") }
                    if let e = vm.error { Text(e).foregroundStyle(.red) }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

                if let s = vm.summary {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary").font(.title3.bold())
                        Text(s)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                if let md = vm.markdown {
                    MarkdownView(markdown: md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
        }
        .navigationTitle("Scrape")
    }
}
