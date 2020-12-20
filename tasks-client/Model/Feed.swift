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
	
	private var currentSorting: SortType = .appearence
    
    mutating func pushTask(array ar: [Task], _ type: FeedType) {
//        type == .personal ?
//			personalTasks.append(contentsOf: ar.difference(from: personalTasks)) :
//			groupTasks.append(contentsOf: ar.difference(from: groupTasks))
		
		switch type {
		case .group:
			groupTasks = ar
		case .personal:
			personalTasks = ar
		}
		
		sort(by: currentSorting)
    }
	
	mutating func setTaskDone(for id: Int, _ type: FeedType) {
		switch type {
		case .group:
			let i = groupTasks.firstIndex{$0.id == id}!
			groupTasks[i].done = true
		case .personal:
			let i = personalTasks.firstIndex{$0.id == id}!
			personalTasks[i].done = true
		}
	}
	
	mutating func sort(by sortType: SortType) {
		currentSorting = sortType
		switch sortType {
		case .appearence:
			groupTasks.sort { $0.id > $1.id }
			personalTasks.sort { $0.id > $1.id }
		case .group:
			groupTasks.sort { $0.name < $1.name }
			personalTasks.sort { $0.name < $1.name }
		case .date:
			break
		}
	}
    
    struct Task: Identifiable, Codable, Hashable {
        var id: Int
        var title: String
        var description: String
        var task: String
        var name: String
        var done: Bool?
    }
}
