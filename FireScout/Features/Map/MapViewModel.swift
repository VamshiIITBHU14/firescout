import Foundation
import Combine

@MainActor
final class MapViewModel: ObservableObject {
    @Published var inputURL = "https://www.firecrawl.dev"
    @Published var keyword = "blog"
    @Published var links: [MappedLink] = []
    @Published var isLoading = false
    @Published var error: String?

    private let api: FirecrawlClientType
    init(api: FirecrawlClientType) { self.api = api }

    func run() async {
        isLoading = true; error = nil
        do {
            let res = try await api.map(url: inputURL, search: keyword)
            links = res.links
        }
        catch { self.error = error.localizedDescription }
        isLoading = false
    }
}
