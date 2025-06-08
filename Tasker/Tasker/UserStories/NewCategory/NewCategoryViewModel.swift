//
//  NewCategoryViewModel.swift
//  Tasker
//
//  Created by Roman Apanasevich on 13.04.2025.
//

import SwiftUI

@Observable
final class NewCategoryViewModel: ObservableObject {
	var trackerCategory: String = ""
	var emoji: String = ""
	var selectedColor: Color?
	var isPresentedEmoji: Bool = false
}
