//
//  FeedType.swift
//  tasks-client
//
//  Created by milkyway on 29.09.2020.
//

import Foundation

enum FeedType {
    case group, personal
    
    mutating func toggle() {
        switch self {
        case .group:
            self = .personal
        case .personal:
            self = .group
        }
    }
}
