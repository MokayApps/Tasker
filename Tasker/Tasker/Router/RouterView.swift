//
//  RouterView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 02.02.2025.
//

import SwiftUI
import MokayDI

struct RouterView<Content: View>: View where Content: Sendable {
    
    let container: Container
    @State var router: Router
    
    init(
        container: Container,
        router: Router
    ) {
        self.container = container
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            container.resolve(Content.self)
                .navigationDestination(for: Screen.self) { screen in
                    router.view(for: screen)
                }
        }
        .environment(router)
        .sheet(item: $router.presentedScreen) { screen in
            router.routerView(for: screen)
        }
    }
}
