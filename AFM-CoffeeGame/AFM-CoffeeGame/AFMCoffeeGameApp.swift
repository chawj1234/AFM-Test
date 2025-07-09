/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The root of the app.
*/

import SwiftUI

@main
struct AFMCoffeeGameApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                #if os(iOS)
                    .statusBar(hidden: true)
                #endif
        }
    }
}
