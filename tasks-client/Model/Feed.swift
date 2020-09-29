//
//  Tasks.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import Foundation

struct Feed {
    var personalTasks = [Task]()
    var groupTasks = [Task]()
    
//    init(id: Int, username: String) {
//        self.id = id
//        self.username = username
//    }
    
    mutating func pushTask(array ar: [Task], _ type: FeedType) {
        type == .personal ? personalTasks.append(contentsOf: ar) : groupTasks.append(contentsOf: ar)
    }
    
    struct Task: Identifiable, Codable {
        var id: Int
        var title: String
        var description: String
    }
}
