
import Foundation

struct FirecrawlConfig {
    let baseURL = URL(string: "https://api.firecrawl.dev")!
    var apiKey: String?
}

protocol FirecrawlClientType {
    func map(url: String, search: String?) async throws -> MapResponse
    func scrape(url: String, formats: [ScrapeFormat]) async throws -> ScrapeResponse
    func extract(urls: [String], prompt: String, schema: [String: Any]?, showSources: Bool) async throws -> ExtractStart
    func search(query: String, limit: Int, formats: [ScrapeFormat]) async throws -> SearchResponse
}

final class FirecrawlClient: FirecrawlClientType {
    private let http: HTTPClient
    private var config: FirecrawlConfig

    init(http: HTTPClient, config: FirecrawlConfig) {
        self.http = http
        self.config = config
    }

    private func request(path: String, body: Any) throws -> URLRequest {
        guard let key = config.apiKey, !key.isEmpty else { throw HTTPError.missingAPIKey }
        var req = URLRequest(url: config.baseURL.appendingPathComponent("/v2/\(path)"))
        req.httpMethod = "POST"
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        return req
    }

    func map(url: String, search: String?) async throws -> MapResponse {
        var body: [String: Any] = [
            "url": url,
            "sitemap": "include",
            "includeSubdomains": true,
            "ignoreQueryParameters": true,
            "limit": 2000
        ]
        if let s = search, !s.isEmpty { body["search"] = s }
        let req = try request(path: "map", body: body)
        return try await http.send(req, decode: MapResponse.self)
    }

    func scrape(url: String, formats: [ScrapeFormat]) async throws -> ScrapeResponse {
        let body: [String: Any] = [
            "url": url,
            "formats": formats.map { $0.asAny },
            "onlyMainContent": true,
            "blockAds": true,
            "storeInCache": true
        ]
        let req = try request(path: "scrape", body: body)
        return try await http.send(req, decode: ScrapeResponse.self)
    }

    func extract(urls: [String], prompt: String, schema: [String: Any]?, showSources: Bool) async throws -> ExtractStart {
        var body: [String: Any] = [
            "urls": urls,
            "prompt": prompt,
            "showSources": showSources,
            "ignoreInvalidURLs": true
        ]
        if let schema = schema { body["schema"] = schema }
        let req = try request(path: "extract", body: body)
        return try await http.send(req, decode: ExtractStart.self)
    }

    func search(query: String, limit: Int, formats: [ScrapeFormat]) async throws -> SearchResponse {
        let body: [String: Any] = [
            "query": query,
            "limit": limit,
            "sources": ["web"],
            "scrapeOptions": [
                "formats": formats.map { $0.asAny },
                "onlyMainContent": true
            ]
        ]
        let req = try request(path: "search", body: body)
        return try await http.send(req, decode: SearchResponse.self)
    }
}
