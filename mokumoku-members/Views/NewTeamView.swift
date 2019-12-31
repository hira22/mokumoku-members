//
//  NewTeamView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/25.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct NewTeamView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject(initialValue: Team()) var team: Team
    
    @State var isPrivate: Bool = false
    
    @State var isAuthViewPresent: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("new team name...", text: self.$team[\.name])
                Toggle(isOn: $isPrivate){
                    Text("Private Team")
                }
            }
            .sheet(isPresented: $isAuthViewPresent) {
                AuthView()
            }
            .navigationBarTitle("New Team")
            .navigationBarItems(
                trailing: Button("save") {
                    guard let user = self.sessionStore.user else {
                        self.isAuthViewPresent = true
                        return
                    }
                    self.team[\.owners] = .arrayUnion([user.id])
                    self.team[\.members] = .arrayUnion([user.id])
                    self.team[\.type] = self.isPrivate ? Team.Model.TeamType.closed.rawValue : Team.Model.TeamType.opened.rawValue
                    self.team.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            )
        }
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        NewTeamView()
    }
}
