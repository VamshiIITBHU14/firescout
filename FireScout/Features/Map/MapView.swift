import SwiftUI

struct MapView: View {
    @StateObject var vm: MapViewModel
    @EnvironmentObject private var themeStore: ThemeStore
    var onSelect: (String) -> Void

    var body: some View {
        ZStack {
            themeStore.theme.gradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Card for controls
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("https://example.com", text: $vm.inputURL)
                            .textFieldStyle(.roundedBorder)

                        TextField("Filter e.g. blog", text: $vm.keyword)
                            .textFieldStyle(.roundedBorder)

                        HStack {
                            Spacer()
                            Button("Map") { Task { await vm.run() } }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                    if vm.isLoading { ProgressView("Mapping…") }
                    if let e = vm.error { Text(e).foregroundStyle(.red) }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

                // List content
                List(vm.links) { link in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(link.title ?? link.url).font(.headline)
                        if let d = link.description { Text(d).font(.subheadline).foregroundStyle(.secondary) }
                        Text(link.url).font(.footnote).foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(link.url) }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .padding()
        }
        .navigationTitle("Map")
    }
}
