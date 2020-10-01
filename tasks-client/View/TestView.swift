//
//  TestView.swift
//  tasks-client
//
//  Created by milkyway on 01.10.2020.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<5) { _ in
                    CardVew(title: "Работа над ошибками", description: "Принести до следующей субботы", name: "Методы и срдества программного обеспеченияМетоды и срдества программного обеспечения", task: "test")
                        .contextMenu(/*@START_MENU_TOKEN@*/ContextMenu(menuItems: {
                            Text("Menu Item 1")
                            Text("Menu Item 2")
                            Text("Menu Item 3")
                        })/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
