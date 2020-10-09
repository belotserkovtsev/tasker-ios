//
//  FeedFetcher.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

class FeedFetcher: ObservableObject {
    @Published var feedData = Feed()
    
//    init(model: Feed) {
//        feedData = model
//    }
    
    var personalTasks: [Feed.Task] {
        feedData.personalTasks
    }
    
    var groupTasks: [Feed.Task] {
        feedData.groupTasks
    }
    
    
    
    func updateFeed(for id: Int, _ type: FeedType) {
        var getFeedUrl: URL
//        var isDoneUrl: URL
        if type == .personal {
            getFeedUrl = URL(string: "http://192.168.1.222:8888/api/getUserTasks?userId=\(id)")!
        } else {
            getFeedUrl = URL(string: "http://192.168.1.222:8888/api/getGroupTasks?userId=\(id)")!
        }
//        isDoneUrl = URL(string: "http://192.168.1.222:8888/api/getGroupTasks?userId=\(id)")!
        
        var feedRequest = URLRequest(url: getFeedUrl)
        feedRequest.httpMethod = "GET"
        feedRequest.timeoutInterval = 2
        
        let session = URLSession.shared
        session.dataTask(with: feedRequest) { (data, response, error) in
            if let data = data {
                do {
                    let resp: FeedData = try JSONDecoder().decode(FeedData.self, from: data)
                    if let userData = resp.tasks {
                        print(userData)
                        DispatchQueue.main.async {
                            self.feedData.pushTask(array: userData, type)
                        }
                    }
//                    print(test)
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    func fetchDone(user: Int, task: Int) {
        var isDoneUrl: URL
        isDoneUrl = URL(string: "http://192.168.1.222:8888/api/isTaskDone?userId=\(user)&taskId=\(task)")!
        
        var request = URLRequest(url: isDoneUrl)
        request.httpMethod = "GET"
        request.timeoutInterval = 2
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let resp: DoneData = try JSONDecoder().decode(DoneData.self, from: data)
                    if let done = resp.done {
                        if done {
                            //TODO: push to model
                        }
                    }
//                    print(test)
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
}
