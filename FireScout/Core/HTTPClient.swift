
import Foundation

public protocol HTTPClient {
    func send<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T
}

public enum HTTPError: Error, LocalizedError {
    case missingAPIKey, invalidResponse, status(Int, Data)

    public var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "Firecrawl API key not set."
        case .invalidResponse: return "Invalid server response."
        case .status(let code, _): return "HTTP \(code) error."
        }
    }
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) { self.session = session }

    public func send<T: Decodable>(_ request: URLRequest, decode: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw HTTPError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw HTTPError.status(http.statusCode, data) }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
