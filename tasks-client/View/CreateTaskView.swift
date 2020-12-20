//
//  CreateTaskView.swift
//  tasks-client
//
//  Created by belotserkovtsev on 20.12.2020.
//

import SwiftUI

struct CreateTaskView: View {
	@EnvironmentObject var feed: FeedWorker
	@EnvironmentObject var user: UserWorker
	
	@State private var title = ""
	@State private var description = ""
	@State private var task = ""
	@State private var isPersonalTask = false
	@State private var group = ""
	@State private var subject = ""
	@State private var studentId = ""
	
    var body: some View {
		NavigationView {
			VStack {
				ZStack {
					RoundedRectangle(cornerRadius: 14)
						.foregroundColor(Color("inputFieldBlack"))
					TextField("Заголовок", text: $title)
						.padding(.leading, 20)
				}
				.frame(width: 359, height: 56)
				.padding(.bottom, 8)
				.padding(.top, 20)
				
				ZStack {
					RoundedRectangle(cornerRadius: 14)
						.foregroundColor(Color("inputFieldBlack"))
					TextField("Цель работы", text: $description)
						.padding(.leading, 20)
				}
				.frame(width: 359, height: 56)
				.padding(.bottom, 8)
				
				ZStack {
					RoundedRectangle(cornerRadius: 14)
						.foregroundColor(Color("inputFieldBlack"))
					TextField("Описание", text: $task)
						.padding(.leading, 20)
				}
				.frame(width: 359, height: 56)
				.padding(.bottom, 8)
				
				Toggle(isOn: $isPersonalTask) {
					Text("Персональное задание")
//						.padding([.leading, .trailing], 12)
//						.padding(.leading, 12)
				}.frame(width: 359, height: 56)
				.padding(.bottom, 8)
				
				if isPersonalTask {
					ZStack {
						RoundedRectangle(cornerRadius: 14)
							.foregroundColor(Color("inputFieldBlack"))
						TextField("Название предмета", text: $subject)
							.padding(.leading, 20)
					}
					.frame(width: 359, height: 56)
					.padding(.bottom, 8)
					.animation(.easeIn)
					.transition(.slide)
					
					ZStack {
						RoundedRectangle(cornerRadius: 14)
							.foregroundColor(Color("inputFieldBlack"))
						TextField("id студента", text: $studentId)
							.padding(.leading, 20)
					}
					.frame(width: 359, height: 56)
					.animation(.easeIn)
					.transition(.slide)
					
				} else {
					ZStack {
						RoundedRectangle(cornerRadius: 14)
							.foregroundColor(Color("inputFieldBlack"))
						TextField("Группа", text: $group)
							.padding(.leading, 20)
					}
					.frame(width: 359, height: 56)
					.padding(.bottom, 8)
					.animation(.easeIn)
					.transition(.slide)
				}
				Spacer()
				Button(action: {
					if !isPersonalTask {
						feed.create(
							userId: user.id!,
							title: title,
							description: description,
							task: task,
							group: group) { result in }
					} else {
						feed.create(
							userId: user.id!,
							title: title,
							description: description,
							task: task,
							group: "",
							name: subject,
							studentId: Int(studentId)) { result in }
					}
				}){
					ZStack {
						RoundedRectangle(cornerRadius: 14)
							.frame(width: 359, height: 58)
							.foregroundColor(Color("loginButtonPink"))
						Text("Создать")
							.font(.system(size: 17, weight: .semibold))
							.foregroundColor(.white)
					}
				}
				
				
				
			}
				
				
			.padding([.leading, .trailing], 12)
			.navigationBarTitle("Создать задание", displayMode: .inline)
			.navigationBarItems(trailing: cross)
		}
    }
	
	var cross: some View {
		Image(systemName: "xmark.circle.fill")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.foregroundColor(Color("cancelGray"))
			.frame(width: 22, height: 22)
	}
}

struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTaskView()
    }
}
