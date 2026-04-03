import SwiftUI

@main
struct EssentialsApp: App {
    @StateObject private var theme = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(theme)
                .preferredColorScheme(theme.colorScheme)
        }
    }
}
