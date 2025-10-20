
import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = "site:apple.com swift concurrency"
    @Published var results: [SearchItem] = []
    @Published var isLoading = false
    @Published var error: String?

    private let api: FirecrawlClientType
    init(api: FirecrawlClientType) { self.api = api }

    func run() async {
        isLoading = true; error = nil
        do {
            let res = try await api.search(query: query, limit: 5, formats: [.markdown, .summary])
            results = res.data.web ?? []
        } catch { self.error = error.localizedDescription }
        isLoading = false
    }
}
