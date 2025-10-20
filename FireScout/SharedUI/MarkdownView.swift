
import SwiftUI

struct MarkdownView: View {
    let markdown: String
    var body: some View {
        ScrollView {
            if let attributed = try? AttributedString(markdown: markdown) {
                Text(attributed).padding()
            } else {
                Text(markdown).monospaced().padding()
            }
        }
    }
}
