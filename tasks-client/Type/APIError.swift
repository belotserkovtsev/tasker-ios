//
//  APIError.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

struct APIError: Codable {
    var id: Int
    var message: String
}

enum Result {
    case success, failure(APIError)
}
