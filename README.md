# FireScout — SwiftUI + MVVM demo for Firecrawl v2

> An interview-ready iOS app that showcases **Firecrawl**’s core endpoints with **SwiftUI**, **MVVM**, **async/await**, **dependency injection**, **Keychain** secrets, and **unit tests**.

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B-blue)
![Swift](https://img.shields.io/badge/swift-5.9%2B-orange)
![License](https://img.shields.io/badge/license-MIT-green)


<img width="200" alt="FS1" src="https://github.com/user-attachments/assets/c90b00eb-667f-454c-8f77-e702cd5415d3" />
<img width="200" alt="FS4" src="https://github.com/user-attachments/assets/fec094e8-a323-42c1-bea2-8a00d4f533ec" />
<img width="200" alt="FS3" src="https://github.com/user-attachments/assets/6803c7c1-3019-449b-8c48-7efd29eb4fee" />
<img width="200" alt="FS2" src="https://github.com/user-attachments/assets/b11812af-d9c1-4897-b7ab-c473c209ca9f" />


---

## ✨ What’s inside
- **Map** a site (`POST /v2/map`) to discover relevant URLs (docs, blog, pricing).
- **Scrape** a page (`POST /v2/scrape`) returning **Markdown** + optional **Summary/Links/Screenshot**.
- **Extract** structured data (`POST /v2/extract`) using **prompt + JSON Schema**, returns a **job id**.
- **Search** the web (`POST /v2/search`) with built‑in scrape options (markdown/summary).

> 🔐 **API key is injectable at runtime** via a Settings screen and stored in **Keychain**.  
> 🧪 **Unit tests included** for the HTTP/Client layer and ViewModels.

---

## 🧱 Project structure
```
FireScout/
 ├─ FireScoutApp.swift
 ├─ Core/
 │   ├─ Secrets.swift            # Keychain-backed SecretStore
 │   ├─ HTTPClient.swift         # URLSession-based client + errors
 │   ├─ FirecrawlClient.swift    # Typed wrapper around v2 endpoints
 │   ├─ Models.swift             # Codable DTOs
 │   └─ DI.swift                 # AppContainer for DI
 ├─ Features/
 │   ├─ Map/     (MapView, MapViewModel)
 │   ├─ Scrape/  (ScrapeView, ScrapeViewModel)
 │   ├─ Extract/ (ExtractView, ExtractViewModel)
 │   └─ Search/  (SearchView, SearchViewModel)
 ├─ SharedUI/
 │   ├─ MarkdownView.swift
 │   └─ SettingsView.swift
 └─ Tests/
     ├─ FirecrawlClientTests.swift
     └─ ViewModelTests.swift
```

---

## 🧩 Key endpoints & payloads
- **Map** — `POST https://api.firecrawl.dev/v2/map`
  ```json
  { "url": "https://example.com", "sitemap": "include", "includeSubdomains": true, "limit": 2000, "search": "blog" }
  ```
- **Scrape** — `POST https://api.firecrawl.dev/v2/scrape`
  ```json
  { "url": "https://example.com/page", "formats": ["markdown","summary"], "onlyMainContent": true, "storeInCache": true }
  ```
- **Extract** — `POST https://api.firecrawl.dev/v2/extract`
  ```json
  { "urls": ["https://example.com/pricing"], "prompt": "Extract pricing tiers", "schema": { "...": "JSON Schema" }, "showSources": true }
  ```
- **Search** — `POST https://api.firecrawl.dev/v2/search`
  ```json
  { "query": "site:apple.com swift concurrency", "limit": 5, "sources": ["web"], "scrapeOptions": { "formats": ["markdown","summary"] } }
  ```

**Headers for all requests**
```
Authorization: Bearer <YOUR_FIRECRAWL_API_KEY>
Content-Type: application/json
```

---

## 🚀 Getting started
1. Create a new Xcode **iOS App (SwiftUI, iOS 16+)** project named `FireScout`.
2. Drop the `Core`, `Features`, `SharedUI`, `Tests`, and `FireScoutApp.swift` into your project (Copy items if needed).
3. Run the app → **Settings** tab → paste your Firecrawl API key (starts with `fc-…`).

**Package manager**: The project is SPM-ready if you split modules, but ships as a single target for simplicity.

---

## 🏗️ Architecture notes
- **MVVM** with observable `ViewModel`s (MainActor), async methods for network calls.
- **Dependency Injection** via `AppContainer` (swap concrete `HTTPClient`/`FirecrawlClientType` in tests).
- **Error handling** bubbles up to `ViewModel` and is rendered as UI toasts/messages.
- **Keychain** stores the API key; `AppContainer.updateAPIKey(_:)` re-hydrates clients.

```swift
final class AppContainer: ObservableObject {
  @Published var secretStore: SecretStore
  @Published var client: FirecrawlClientType

  init() {
    let store = KeychainSecretStore()
    let cfg  = FirecrawlConfig(apiKey: store.apiKey)
    secretStore = store
    client = FirecrawlClient(http: URLSessionHTTPClient(), config: cfg)
  }
}
```

---

## 🧪 Testing
- **Client tests** validate request building (headers, path) and JSON decoding.
- **ViewModel tests** use a **Stub API** to assert UI state updates.

Run from Xcode (`⌘U`) or via CLI:
```bash
xcodebuild -scheme FireScout -destination 'platform=iOS Simulator,name=iPhone 15' test
```

---

## 🖼️ Screens (suggested)
- **Map**: domain + keyword input → list of discovered links.
- **Scrape**: URL input → Summary + Markdown render.
- **Extract**: multi-URL + prompt + schema text editors → job id feedback.
- **Search**: query input (supports `site:`) → list → Markdown detail.

---

## 🧰 Troubleshooting
- **401/403**: Check API key (Settings) and Firecrawl account permissions.
- **429**: You’ve hit a rate/credit limit—back off and retry with exponential strategy.
- **Non-200**: The app surfaces `HTTPError.status(code, data)`; check server response text in logs.

---

## 🗺️ Roadmap
- ✅ v1: Map, Scrape, Extract (submit), Search
- ⏭️ v1.1: Extract **status polling** screen
- ⏭️ v1.2: Scrape **screenshots** gallery (`{ "type": "screenshot" }` format)
- ⏭️ v1.3: Offline cache + Markdown export

---

## 📄 License
MIT — see `LICENSE` (or keep this README section if you prefer).

---

### Credits
- Built for the Firecrawl API. This project is independent and not affiliated with Firecrawl.
