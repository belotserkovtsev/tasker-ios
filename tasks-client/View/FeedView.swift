//
//  FeedView.swift
//  tasks-client
//
//  Created by milkyway on 27.09.2020.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var feed: FeedFetcher
    @EnvironmentObject var user: UserAuth
    
    
    @State var display: FeedType = .group
    
    var body: some View {
        VStack(spacing: .zero) {
            FeedHeaderView(firstname: user.firstname!, lastname: user.lastname!)
            
            HStack {
                Text("Мои задания")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.leading, 12)
                    .padding(.bottom, 16)
                Spacer()
            }
            
            FeedSelectorView(selection: $display)
            
            Group {
                if display == .group {
                    GroupTasksView()
                        .animation(Animation.easeOut(duration: 0.25))
                        .transition(.move(edge: .leading))
                } else {
                    PersonalTasksView()
                        .animation(Animation.easeOut(duration: 0.25))
                        .transition(.slide)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .gesture(swipe())
        }
        
        
    }
    
    private func swipe() -> some Gesture {
        return DragGesture(minimumDistance: 3)
            .onEnded { value in
            if value.translation.width < 0 && display == .group{
                display.toggle()
            } else if value.translation.width > 0 && display == .personal {
                display.toggle()
            }
        }
    }
}

struct GroupTasksView: View {
    @EnvironmentObject var feed: FeedFetcher
    @EnvironmentObject var user: UserAuth
    @State var showCards = false
    
    var body: some View {
        VStack(spacing: .zero) {
            if showCards {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(feed.groupTasks) { task in
                            CardVew(title: task.title, description: task.description, name: task.name, task: task.task)
                        }
                    }
                }
                .transition(.move(edge: .leading))
            }
            Spacer()
        }
        .onAppear {
            if feed.groupTasks.count == 0 {
                feed.fetch(for: user.id!, .group)
            }
        }
        .onReceive(feed.$feedData) { feedData in
            if feedData.groupTasks.count > 0 {
                withAnimation(.easeOut(duration: 0.3)) {
                    showCards = true
                }
            }
        }
    }
}

struct PersonalTasksView: View {
    @EnvironmentObject var feed: FeedFetcher
    @EnvironmentObject var user: UserAuth
    
    @State var showCards = false
    
    var body: some View {
        VStack(spacing: .zero) {
            if showCards {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(feed.personalTasks) { task in
                            CardVew(title: task.title, description: task.description, name: task.name, task: task.task)
                        }
                    }
                }
                .transition(.move(edge: .trailing))
            }
            Spacer()
        }
        .onAppear {
            if feed.personalTasks.count == 0 {
                feed.fetch(for: user.id!, .personal)
            }
        }
        .onReceive(feed.$feedData) { feedData in
            if feedData.personalTasks.count > 0 {
                withAnimation(.easeOut(duration: 0.3)) {
                    showCards = true
                }
            }
        }
    }
}

struct FeedHeaderView: View {
    var firstname: String
    var lastname: String
    
    var body: some View {
        HStack(spacing: 19) {
            ZStack {
                Circle()
                    .foregroundColor(Color("loginButtonPink"))
                Text("B")
                    .font(.system(size: 22, weight: .bold))
            }
            .frame(width: 42, height: 42)
            
            VStack(alignment: .leading) {
                Text("\(firstname) \(lastname)")
                Text("Исполнитель")
                    .foregroundColor(Color("captionGray"))
            }
            .font(.system(size: 16))
            Spacer()
        }
        .padding(.leading, 12)
        .padding(.top, 16)
        .padding(.bottom, 30)
    }
}

struct FeedSelectorView: View {
    @Binding var selection: FeedType
    
    var body: some View {
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
        .padding(.leading, 12)
        .padding(.bottom, 8)
        
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color("selectorPink"))
                .frame(width: selection == .group ? 86 : 64, height: 3)
                .padding(.leading, selection == .group ? 12 : 117)
                .animation(.easeOut)
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

struct CardVew: View {
    var title: String
    var description: String
    var name: String
    var task: String
    
    let tapVibration = UIImpactFeedbackGenerator(style: .light)
    @State var details = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("cardGray"))
                .opacity(0.24)
            VStack(alignment: .leading, spacing: .zero) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 244, alignment: .leading)
                    .padding(.bottom, 4)
                Text(description)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 247, alignment: .leading)
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
                        .frame(width: 211, alignment: .trailing)
                }
            }
            .padding([.leading, .trailing], 12)
            .padding(.bottom, 15)
            .padding(.top, 24)
            
        }
        .frame(minHeight: 153)
        .padding([.leading, .trailing], 12)
        .sheet(isPresented: $details) {
            CardSheetView(title: title, description: description, task: task, name: name)
        }
        .onTapGesture {
            tapVibration.impactOccurred()
            details = true
        }
        .onAppear {
            tapVibration.prepare()
        }
    }
//    @GestureState var active = false
//
//    func tap() -> some Gesture {
//        LongPressGesture(minimumDuration: 0.01)
//            .updating($active) { _, gestureState ,_ in
//            gestureState = true
//        }
//    }
}

struct CardSheetView: View {
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
                        HStack(alignment: .center) {
                            Text(title)
                                .font(.system(size: 22, weight: .bold))
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

struct FeedView_Previews: PreviewProvider {
    static var user: UserAuth {
        let temp = UserAuth()
        temp.login(user: "Bogdan"){_ in}
        return temp
    }
    
    static var previews: some View {
        ScrollView {
            CardVew(title: "Работа над ошибками", description: "Принести до следующей субботы", name: "Методы и срдества программного обеспеченияМетоды и срдества программного обеспечения", task: "test")
                .contextMenu(/*@START_MENU_TOKEN@*/ContextMenu(menuItems: {
                    Text("Menu Item 1")
                    Text("Menu Item 2")
                    Text("Menu Item 3")
                })/*@END_MENU_TOKEN@*/)
        }
            .preferredColorScheme(.dark)
    }
    
//    static var previews: some View {
//        CardSheetView(title: "Лабораторная №1", description: "Сделать веб-страницу со стилями", task: "Тестовое описание Тестовое описание Тестовое описание ", name: "ML M3306")
//            .preferredColorScheme(.dark)
//    }
}
