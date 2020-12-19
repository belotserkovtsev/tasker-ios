//
//  FeedView.swift
//  tasks-client
//
//  Created by milkyway on 23.10.2020.
//

import SwiftUI

struct FeedView: View {
	@EnvironmentObject var feed: FeedWorker
	@EnvironmentObject var user: UserWorker
	
	
	@State private var displayFeed: FeedType = .group
	@State private var displaySettings = false
	
    var body: some View {
		NavigationView {
			ScrollView {
				FeedSelectorView(selection: $displayFeed)
				VStack(spacing: 16) {
					if displayFeed == .group {
						GroupTasksView(currentFeed: $displayFeed)
							.transition(.move(edge: .leading))
							.animation(Animation.easeOut(duration: 0.25))
					} else {
						PersonalTasksView(currentFeed: $displayFeed)
							.transition(.slide)
							.animation(Animation.easeOut(duration: 0.25))
					}
				}
				.gesture(swipe())
			}
			.padding(.top, 1)
			.navigationBarTitle("Мои задания")
			.navigationBarItems(
				leading: user.userType! == .head ?
					AnyView(addNewTaskItem) : AnyView(EmptyView()),
				trailing: sortAndRefreshItems
			)
			.actionSheet(isPresented: $displaySettings) { settings }
			.alert(isPresented: $displayAlert) { alertToDisplay! }
			
		}
    }
	
	private var addNewTaskItem: some View {
		Button(action: {
			
		}, label: {
			Image(systemName: "plus")
				.foregroundColor(.purple)
				.frame(width: 32, height: 32)
		})
	}
	
	@State private var displayProgress: (group: Bool, personal: Bool) = (false, false)
	@State private var displayAlert = false
	@State private var alertToDisplay: Alert?
	
	private func makeExceptionAlert(text: String) -> Alert {
		Alert(
			title: Text("Произошла ошибка"),
			message: Text(text),
			dismissButton: .default(Text("Хорошо")){alertToDisplay = nil}
		)
	}
	
	private var sortAndRefreshItems: some View {
		HStack(spacing: .zero) {
			Button(action: {
				displaySettings = true
			}, label: {
				Image(systemName: "arrow.up.arrow.down")
					.foregroundColor(.purple)
					.frame(width: 32, height: 32)
			})
			
			Button(action: {
				displayProgress = (true, true)
				
				feed.updateFeed(for: user.id!, .group) { result in
					switch result {
					case .success:
						displayProgress.group = false
					case .failure(let err):
						if alertToDisplay == nil && !displayAlert {
							alertToDisplay = makeExceptionAlert(text: err.message)
							displayAlert = true
						}
						displayProgress.group = false
					}
					
				}
				
				feed.updateFeed(for: user.id!, .personal) { result in
					switch result {
					case .success:
						displayProgress.personal = false
					case .failure(let err):
						if alertToDisplay == nil && !displayAlert {
							alertToDisplay = makeExceptionAlert(text: err.message)
							displayAlert = true
						}
						displayProgress.personal = false
					}
				}
			}, label: {
				if displayProgress.group || displayProgress.personal {
					ProgressView()
						.frame(width: 32, height: 32)
				} else {
					Image(systemName: "arrow.clockwise")
						.foregroundColor(.purple)
						.frame(width: 32, height: 32)
				}
			})
		}
	}
	
	private var settings: ActionSheet {
		ActionSheet(
			title: Text("Отсортировать задачи"),
			buttons: [
				.default(Text("По предмету")){
					feed.sort(by: .group)
				},
				.default(Text("По дате")),
				.default(Text("По появлению")) {
					feed.sort(by: .appearence)
				},
				.cancel(Text("Отмена"))
			]
		)
	}
	
	private func swipe() -> some Gesture {
		return DragGesture(minimumDistance: 3)
			.onEnded { value in
				if value.translation.width < 0 && displayFeed == .group {
					displayFeed.toggle()
				} else if value.translation.width > 0 && displayFeed == .personal {
					displayFeed.toggle()
				}
			}
	}
}

struct GroupTasksView: View {
	@EnvironmentObject var feed: FeedWorker
	@EnvironmentObject var user: UserWorker
	@State var showCards = false
	
	@Binding var currentFeed: FeedType
	
	var body: some View {
		Group {
			if !feed.groupTasks.isEmpty {
				cards
					.transition(.move(edge: .leading))
			} else {
				GeometryReader { geo in
					Spacer()
						.frame(
							width: geo.size.width,
							height: geo.size.height,
							alignment: .center
						)
				}
			}
		}
		.onAppear {
			feed.updateFeed(for: user.id!, .group) { result in
				//some result handler
			}
		}
	}
	
	private var cards: some View {
		ForEach(feed.groupTasks) { task in
			CardVew(task: task, currentFeed: $currentFeed)
		}
	}
}

struct PersonalTasksView: View {
	@EnvironmentObject var feed: FeedWorker
	@EnvironmentObject var user: UserWorker
	
	@State var showCards = false
	@Binding var currentFeed: FeedType
	
	var body: some View {
		Group {
			if !feed.personalTasks.isEmpty {
				cards
					.transition(.move(edge: .trailing))
			} else {
				GeometryReader { geo in
					Spacer()
						.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
				}
			}
			
		}
		.onAppear {
			feed.updateFeed(for: user.id!, .personal) {result in
				
			}
		}
	}
	
	private var cards: some View {
		ForEach(feed.personalTasks) { task in
			CardVew(task: task, currentFeed: $currentFeed)
		}
	}
}

struct FeedSelectorView: View {
	@Binding var selection: FeedType
	
	var body: some View {
		VStack(spacing: 8) {
			HStack(spacing: 20) {
				Text("Групповые")
					.onTapGesture {
						selection = .group
					}
				Text("Личные")
					.onTapGesture {
						selection = .personal
					}
				Spacer()
			}
			
			HStack {
				RoundedRectangle(cornerRadius: 5)
					.foregroundColor(Color("selectorPink"))
					.frame(width: selection == .group ? 86 : 64, height: 3)
					.padding(.leading, selection == .group ? 0 : 105)
					.animation(.easeOut)
				Spacer()
			}
			
		}
		
		.padding(.leading, 16)
		.padding([.top, .bottom], 8)
	}
}

//struct FeedView_Previews: PreviewProvider {
//	@State static var display: FeedType = .group
//	static var previews: some View {
//		NavigationView {
//			ScrollView {
//				FeedSelectorView(selection: $display)
//				VStack(spacing: 16) {
//					
//					CardVew(title: "Работа над ошибками", description: "Принести до следующей субботы", name: "Методы и срдества программного обеспечения", task: "test", done: false)
//
//					CardVew(title: "Долг матан", description: "Сдатьв четверг в ауд. 118", name: "Математический анализ", task: "test", done: false)
//				}
//
//			}
//			.padding(.top, 1)
//			.navigationBarTitle("Мои задания")
//		}
//		.preferredColorScheme(.dark)
//	}
//}
