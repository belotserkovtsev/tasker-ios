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
            FeedHeaderView(name: user.username!)
            
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
                        .animation(Animation.easeOut)
                        .transition(.move(edge: .leading))
                } else {
                    PersonalTasksView()
                        .animation(Animation.easeOut)
                        .transition(.slide)
                }
            }.gesture(swipe())
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
                        ForEach(0..<feed.groupTasks.count) { i in
                            CardVew(title: feed.groupTasks[i].title, description: feed.groupTasks[i].description)
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
                withAnimation(.easeOut) {
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
                        ForEach(0..<feed.personalTasks.count) { i in
                            CardVew(title: feed.personalTasks[i].title, description: feed.personalTasks[i].description)
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
                withAnimation(.easeOut) {
                    showCards = true
                }
            }
        }
    }
}

struct FeedHeaderView: View {
    var name: String
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
                Text(name)
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
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("cardGray"))
                .opacity(0.24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                Text(description)
                    .opacity(0.8)
                Spacer()
                HStack {
                    Image(systemName: "calendar")
                    Text("22.09")
                    Spacer()
                    Text("Машинное обучение")
                        .opacity(0.6)
                        .font(.footnote)
                }
            }
            .padding([.leading, .trailing], 12)
            .padding(.bottom, 15)
            .padding(.top, 24)
        }
        .frame(minHeight: 153)
        .padding([.leading, .trailing], 12)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var user: UserAuth {
        let temp = UserAuth()
        temp.login(user: "Bogdan")
        return temp
    }
    
    static var previews: some View {
        FeedView()
            .environmentObject(user)
            .preferredColorScheme(.dark)
    }
}