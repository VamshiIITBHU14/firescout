
import Foundation

// MARK: - Map
struct MapResponse: Codable {
    let success: Bool
    let links: [MappedLink]
}
struct MappedLink: Codable, Identifiable {
    var id: String { url }
    let url: String
    let title: String?
    let description: String?
}

// MARK: - Scrape
enum ScrapeFormat {
    case markdown
    case summary
    case links
    case screenshot(fullPage: Bool? = nil, quality: Int? = nil, viewport: [String:Int]? = nil)
    case json(schema: [String: Any], prompt: String?)

    var asAny: Any {
        switch self {
        case .markdown: return "markdown"
        case .summary:  return "summary"
        case .links:    return "links"
        case .screenshot(let full, let quality, let viewport):
            var o: [String: Any] = ["type": "screenshot"]
            if let full = full { o["fullPage"] = full }
            if let quality = quality { o["quality"] = quality }
            if let viewport = viewport { o["viewport"] = viewport }
            return o
        case .json(let schema, let prompt):
            var o: [String: Any] = ["type": "json", "schema": schema]
            if let p = prompt { o["prompt"] = p }
            return o
        }
    }
}

struct ScrapeResponse: Codable {
    let success: Bool
    let data: ScrapeData
}
struct ScrapeData: Codable {
    let markdown: String?
    let summary: String?
    let links: [String]?
    let screenshot: String?
    let metadata: Metadata?
}
struct Metadata: Codable {
    let title: String?
    let description: String?
    let sourceURL: String?
    let statusCode: Int?
    let error: String?
}

// MARK: - Extract
struct ExtractStart: Codable {
    let success: Bool
    let id: String
    let invalidURLs: [String]?
}

// MARK: - Search
struct SearchResponse: Codable {
    let success: Bool
    let data: SearchBuckets
}
struct SearchBuckets: Codable {
    let web: [SearchItem]?
}
struct SearchItem: Codable, Identifiable {
    var id: String { url }
    let title: String?
    let description: String?
    let url: String
    let markdown: String?
}
