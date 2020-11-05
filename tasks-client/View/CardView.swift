//
//  CardView.swift
//  tasks-client
//
//  Created by milkyway on 23.10.2020.
//

import SwiftUI

struct CardVew: View {
	var title: String
	var description: String
	var name: String
	var task: String
	var done: Bool
	
	let tapVibration = UIImpactFeedbackGenerator(style: .light)
	@State var details = false
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 15)
				.foregroundColor(Color("cardGray"))
				.opacity(0.24)
			VStack(alignment: .leading, spacing: .zero) {
				titleBlock
				
				descriptionBlock
				
				bottomBlock
			}
			.padding([.leading, .trailing], 20)
			.padding(.bottom, 15)
			.padding(.top, 24)
			
		}
		.padding([.leading, .trailing], 12)
		.sheet(isPresented: $details) {
			TaskDetailsView(
				title: title,
				description: description,
				task: task,
				name: name
			)
		}
		.onTapGesture {
			tapVibration.impactOccurred()
			details = true
		}
		.onAppear {
			tapVibration.prepare()
		}
	}
	
	private var titleBlock: some View {
		HStack(alignment: .top) {
			Text(title)
				.font(.system(size: 22, weight: .bold))
				.fixedSize(horizontal: false, vertical: true)
				.frame(width: 244, alignment: .leading)
				.padding(.bottom, 4)
			if done {
				Spacer()
				Image("done")
					.opacity(0.8)
			}
		}
	}
	
	private var bottomBlock: some View {
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
				.frame(width: 211, alignment: .trailing)
		}
	}
	
	private var descriptionBlock: some View {
		Text(description)
			.opacity(0.8)
			.fixedSize(horizontal: false, vertical: true)
			.frame(width: 247, alignment: .leading)
			.padding(.bottom, 38)
	}
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		ScrollView {
			CardVew(
				title: "Работа над ошибками",
				description: "Принести до следующей субботы",
				name: "Методы и срдества программного обеспечения",
				task: "test",
				done: false)
		}
    }
}
