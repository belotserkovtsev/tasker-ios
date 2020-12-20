//
//  FeedFetcher.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

class FeedWorker: ObservableObject {
    @Published private var feedData = Feed()
    
//    init(model: Feed) {
//        feedData = model
//    }
    
    var personalTasks: [Feed.Task] {
        feedData.personalTasks
    }
    
    var groupTasks: [Feed.Task] {
        feedData.groupTasks
    }
    
	//MARK: Intents
	
	func sort(by sortType: SortType) {
		feedData.sort(by: sortType)
	}
    
    
	func updateFeed(for id: Int, _ type: FeedType, _ userType: User.UserType, completion: @escaping (Result) -> Void) {
        var getFeedUrl: URL
//        var isDoneUrl: URL
        if type == .personal {
			switch userType {
			case .head:
				getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getHeadUserTasks?userId=\(id)")!
			case .subordinate:
				getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getUserTasks?userId=\(id)")!
			}
        } else {
			switch userType {
			case .head:
				getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getHeadGroupTasks?userId=\(id)")!
			case .subordinate:
				getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getGroupTasks?userId=\(id)")!
			}
        }
//        isDoneUrl = URL(string: "http://192.168.1.222:8888/api/getGroupTasks?userId=\(id)")!
        
        var feedRequest = URLRequest(url: getFeedUrl)
        feedRequest.httpMethod = "GET"
        feedRequest.timeoutInterval = 5
        
        let session = URLSession.shared
        session.dataTask(with: feedRequest) { (data, response, error) in
            if let rawData = data {
                do {
                    let resp: FeedData = try JSONDecoder().decode(FeedData.self, from: rawData)
                    if let userData = resp.tasks {
                        print(userData)
                        DispatchQueue.main.async {
                            self.feedData.pushTask(array: userData, type)
							completion(.success)
                        }
					} else if let err = resp.error {
						completion(.failure(err))
					}
                } catch {
					completion(.failure(APIError(id: 6, message: "Couldn't decode")))
                }
			} else {
				completion(.failure(APIError(id: 5, message: "Server failure")))
			}
        }
        .resume()
    }
	
	func setDone(for id: Int, task taskId: Int, _ type: FeedType, completion: @escaping (Result) -> Void) {
		let getFeedUrl = URL(string: "http://127.0.0.1:8888/api/setTaskDone?userId=\(id)&taskId=\(taskId)")!
		
		var feedRequest = URLRequest(url: getFeedUrl)
		feedRequest.httpMethod = "POST"
		feedRequest.timeoutInterval = 5
		
		let session = URLSession.shared
		session.dataTask(with: feedRequest) { (data, response, error) in
			if let rawData = data {
				do {
					if let httpResponse = response as? HTTPURLResponse {
						if httpResponse.statusCode == 200 {
							DispatchQueue.main.async {
								self.feedData.setTaskDone(for: taskId, type)
								completion(.success)
							}
						} else if httpResponse.statusCode == 400 {
							let resp: ErrorOnlyData = try JSONDecoder().decode(ErrorOnlyData.self, from: rawData)
							
							completion(.failure(resp.error!))
						}
					} else {
						completion(.failure(APIError(id: 7, message: "Couldn't reach server")))
					}
				} catch {
					completion(.failure(APIError(id: 6, message: "Couldn't decode")))
				}
			} else {
				completion(.failure(APIError(id: 5, message: "Server failure")))
			}
		}
		.resume()
	}
	
	func create(userId: Int, title: String, description: String,
				task: String, group: String, name: String? = nil,
				studentId: Int? = nil, completion: @escaping (Result) -> Void) {
		var urlString = ""
		if let subjectName = name, let theStudentId = studentId {
			urlString = "http://127.0.0.1:8888/api/createTask?userId=\(userId)&title=\(title)&description=\(description)&task=\(task)&name=\(subjectName)&id=\(theStudentId)"
		} else {
			urlString = "http://127.0.0.1:8888/api/createTask?userId=\(userId)&title=\(title)&description=\(description)&task=\(task)&group=\(group)"
		}
		urlString = urlString
			.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let getFeedUrl = URL(string: urlString)!
		
		var feedRequest = URLRequest(url: getFeedUrl)
		feedRequest.httpMethod = "POST"
		feedRequest.timeoutInterval = 5
		
		let session = URLSession.shared
		session.dataTask(with: feedRequest) { (data, response, error) in
			if let rawData = data {
				do {
					if let httpResponse = response as? HTTPURLResponse {
						if httpResponse.statusCode == 200 {
							print("sucess!!!")
//							DispatchQueue.main.async {
//								self.feedData.setTaskDone(for: taskId, type)
//								completion(.success)
//							}
						} else if httpResponse.statusCode == 400 {
							let resp: ErrorOnlyData = try JSONDecoder()
								.decode(ErrorOnlyData.self, from: rawData)
							print(resp.error!)
							completion(.failure(resp.error!))
						}
					} else {
						completion(
							.failure(APIError(id: 7, message: "Couldn't reach server")))
					}
				} catch {
					completion(
						.failure(APIError(id: 6, message: "Couldn't decode")))
				}
			} else {
				completion(
					.failure(APIError(id: 5, message: "Server failure")))
			}
		}
		.resume()
	}
}
