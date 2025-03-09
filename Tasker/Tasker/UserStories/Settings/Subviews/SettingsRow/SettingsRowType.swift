//
//  SettingsRowType.swift
//  Tasker
//
//  Created by Дмитрий Бондаренко on 28.01.2025.
//

enum SettingsRowType: Hashable, CaseIterable {
    
    case categories
    case notifications
    case appearance
    case faceID
    
    case telegram
    case email
    case rateApp
    
    case about
    case faq
    case termsOfService
    case privacyPolicy
    
    var actionType: SettingsRowActionType {
        switch self {
        case .categories, .notifications, .appearance, .about:
            return .transition
        case .faceID:
            return ._switch
        default:
            return .link
        }
    }
    
}
