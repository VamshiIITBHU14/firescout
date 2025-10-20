
import Foundation
import Combine

@MainActor
final class ScrapeViewModel: ObservableObject {
    @Published var url: String = ""
    @Published var markdown: String?
    @Published var summary: String?
    @Published var isLoading = false
    @Published var error: String?

    private let api: FirecrawlClientType
    init(api: FirecrawlClientType) { self.api = api }

    func scrape() async {
        guard !url.isEmpty else { return }
        isLoading = true; error = nil
        do {
            let res = try await api.scrape(url: url, formats: [.summary, .markdown])
            markdown = res.data.markdown
            summary  = res.data.summary
        } catch { self.error = error.localizedDescription }
        isLoading = false
    }
}
