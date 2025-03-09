//
//  SearchView.swift
//  Tasker
//
//  Created by Andrei Kozlov on 18/1/25.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(Router.self) var router
    
    var body: some View {
        Text("SearchView")
        Button {
            router.present(.settings)
        } label: {
            Text("Tap me!")
        }

    }
}
