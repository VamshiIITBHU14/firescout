// Theme.swift
// Centralized app theme model and helpers

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable, Identifiable, Codable, Hashable {
    case indigo
    case teal
    case purple

    var id: String { rawValue }

    var name: String {
        switch self {
        case .indigo: return "Indigo"
        case .teal:   return "Teal"
        case .purple: return "Purple"
        }
    }

    var accent: Color {
        switch self {
        case .indigo: return .indigo
        case .teal:   return .teal
        case .purple: return .purple
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .indigo:
            return LinearGradient(colors: [.indigo.opacity(0.12), .blue.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .teal:
            return LinearGradient(colors: [.teal.opacity(0.12), .cyan.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .purple:
            return LinearGradient(colors: [.purple.opacity(0.12), .pink.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

final class ThemeStore: ObservableObject {
    @AppStorage("selectedTheme") private var storedTheme: String = AppTheme.indigo.rawValue
    @Published var theme: AppTheme = .indigo {
        didSet { storedTheme = theme.rawValue }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.indigo.rawValue
        let initial = AppTheme(rawValue: raw) ?? .indigo
        self.theme = initial
        self.storedTheme = initial.rawValue
    }
}
