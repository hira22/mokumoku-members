//
//  ContentView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/24.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct TopView: View {
    @State private var selection: Int = 0
    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        
        VStack {
            if sessionStore.user == nil {
                AuthView()
            } else {
                TabView(selection: $selection) {
                    TeamListView(user: sessionStore.user!)
                        .environmentObject(sessionStore)
                        .tabItem {
                            Image(systemName: "person.and.person")
                            Text("Team") }
                        .tag(0)
                    TaskListView(user: sessionStore.user!)
                        .environmentObject(sessionStore)
                        .tabItem {
                            Image(systemName: "doc.on.doc")
                            Text("Task") }
                        .tag(1)
                    SettingView()
                        .environmentObject(sessionStore)
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Setting") }
                        .tag(2)
                }
            }
            
        }.onAppear {
            self.sessionStore.listen()
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView().environmentObject(SessionStore())
    }
}

