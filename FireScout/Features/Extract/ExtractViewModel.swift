
import Foundation
import Combine

@MainActor
final class ExtractViewModel: ObservableObject {
    @Published var urls = ""
    @Published var prompt = "Extract pricing tiers with features."
    @Published var schemaText = """
    {
      "type": "object",
      "properties": {
        "plans": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": {"type":"string"},
              "price": {"type":"string"},
              "features": {"type":"array","items":{"type":"string"}}
            },
            "required": ["name","price"]
          }
        }
      }
    }
    """
    @Published var submitted: ExtractStart?
    @Published var error: String?
    @Published var isLoading = false

    private let api: FirecrawlClientType
    init(api: FirecrawlClientType) { self.api = api }

    func run() async {
        isLoading = true; error = nil
        do {
            let urlsArr = urls.split(separator: "\n").map { String($0) }
            let schema = try JSONSerialization.jsonObject(with: Data(schemaText.utf8)) as? [String: Any]
            submitted = try await api.extract(urls: urlsArr, prompt: prompt, schema: schema, showSources: true)
        } catch { self.error = error.localizedDescription }
        isLoading = false
    }
}
