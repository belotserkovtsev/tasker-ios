//
//  Tasks.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import Foundation

struct Feed {
    private(set) var personalTasks = [Task]()
    private(set) var groupTasks = [Task]()
    
    mutating func pushTask(array ar: [Task], _ type: FeedType) {
        type == .personal ?
			personalTasks.append(contentsOf: ar.difference(from: personalTasks)) :
			groupTasks.append(contentsOf: ar.difference(from: groupTasks))
		type == .personal ?
			personalTasks.sort{$0.id > $1.id} :
			groupTasks.sort{$0.id > $1.id}
    }
    
    struct Task: Identifiable, Codable, Hashable {
        var id: Int
        var title: String
        var description: String
        var task: String
        var name: String
        var done: Bool
    }
}
