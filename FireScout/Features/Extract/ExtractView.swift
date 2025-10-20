import SwiftUI

struct ExtractView: View {
    @StateObject var vm: ExtractViewModel
    @EnvironmentObject private var themeStore: ThemeStore
    var body: some View {
        ZStack {
            themeStore.theme.gradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("URLs").font(.headline)
                    TextEditor(text: $vm.urls)
                        .frame(minHeight: 80)
                        .padding(8)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .onAppear { if vm.urls.isEmpty { vm.urls = "https://example.com/pricing" } }

                    TextField("Prompt", text: $vm.prompt)
                        .textFieldStyle(.roundedBorder)

                    Text("JSON Schema (optional)").font(.headline)
                    TextEditor(text: $vm.schemaText)
                        .frame(minHeight: 180)
                        .padding(8)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                    HStack {
                        Button("Extract") { Task { await vm.run() } }
                            .buttonStyle(.borderedProminent)
                        if vm.isLoading { ProgressView("Submitting…") }
                    }

                    if let id = vm.submitted?.id {
                        Label("Extraction job started: \(id)", systemImage: "checkmark.circle")
                    }
                    if let e = vm.error { Text(e).foregroundStyle(.red) }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("Extract")
    }
}

