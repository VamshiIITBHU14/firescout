import Combine
import Foundation

final class AppContainer: ObservableObject {
    @Published var secretStore: SecretStore
    @Published var client: FirecrawlClientType

    init() {
        let store = KeychainSecretStore()
        let cfg  = FirecrawlConfig(apiKey: store.apiKey)
        let http = URLSessionHTTPClient()
        self.secretStore = store
        self.client = FirecrawlClient(http: http, config: cfg)
    }

    func updateAPIKey(_ key: String) {
        secretStore.apiKey = key
        let cfg = FirecrawlConfig(apiKey: key)
        client = FirecrawlClient(http: URLSessionHTTPClient(), config: cfg)
    }
}

