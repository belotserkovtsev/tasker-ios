//
//  TaskDetailsView.swift
//  tasks-client
//
//  Created by milkyway on 23.10.2020.
//

import SwiftUI

struct TaskDetailsView: View {
	var title: String
	var description: String
	var task: String
	var name: String
	
	//    @Binding var active: Bool
	
	var body: some View {
		NavigationView {
			VStack(spacing: .zero) {
				ScrollView {
					VStack(alignment: .leading, spacing: .zero) {
						HStack(alignment: .top) {
							Text(title)
								.font(.system(size: 22, weight: .bold))
								.fixedSize(horizontal: false, vertical: true)
								.frame(width: 235, alignment: .leading)
								.padding(.bottom, 4)
							
							Spacer()
							
							ZStack {
								RoundedRectangle(cornerRadius: 12)
									.foregroundColor(Color("typePink"))
								Text("Групповое")
							}
							.frame(maxWidth: 105, maxHeight: 30)
						}
						Text(description)
							.opacity(0.8)
							.fixedSize(horizontal: false, vertical: true)
							.frame(width: 235, alignment: .leading)
							.padding(.bottom, 38)
						
						HStack(alignment: .bottom) {
							HStack(alignment: .center) {
								Image(systemName: "calendar")
								Text("22.09")
							}
							Spacer()
							Text(name)
								.multilineTextAlignment(.trailing)
								.opacity(0.6)
								.font(.footnote)
								.fixedSize(horizontal: false, vertical: true)
								.frame(width: 211, alignment: .trailing)
						}
						
						.padding(.bottom, 15)
						.padding(.top, 20)
						
						Divider()
							.padding(.bottom, 26)
						
						HStack {
							Text("Описание")
								.font(.footnote)
								.opacity(0.5)
							Spacer()
						}
						.padding(.bottom, 10)
						
						GeometryReader { geo in
							Text(task)
								.font(.body)
								.opacity(0.8)
								.fixedSize(horizontal: false, vertical: true)
								.frame(width: geo.size.width, alignment: .leading)
						}
						
						Spacer()
					}.padding(.top, 20)
					
				}
				ZStack {
					RoundedRectangle(cornerRadius: 14)
						.foregroundColor(Color("loginButtonPink"))
						.frame(height: 56)
					Text("Я сделал это!")
						.font(.system(size: 17, weight: .semibold))
				}
			}
			.padding([.leading, .trailing], 12)
			.navigationBarTitle("Задание", displayMode: .inline)
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

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
		TaskDetailsView(
			title: "Работа над ошибками",
			description: "Принести до следующей субботы",
			task: "test",
			name: "Методы и срдества программного обеспечения")
			.preferredColorScheme(.dark)
    }
}
