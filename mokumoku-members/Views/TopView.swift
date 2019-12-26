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
    
    @State var isAuthShow: Bool = false

    var body: some View {
        
        VStack {
            if (sessionStore.session == nil) {
                AuthView()
            } else {
                TabView(selection: $selection) {
                    TeamListView()
                        .environmentObject(sessionStore)
                        .tabItem {
                            Image(systemName: "person.and.person")
                            Text("Team") }
                        .tag(0)
                    Text("You")
                        .tabItem {
                            Image(systemName: "person")
                            Text("You") }
                        .tag(1)
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

