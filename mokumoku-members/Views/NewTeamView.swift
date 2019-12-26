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
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("new team name...", text: self.$team[\.name])
                Toggle(isOn: $isPrivate){
                    Text("private")
                }
            }
            .navigationBarTitle("NewTeam")
            .navigationBarItems(
                trailing: Button("save") {
                    if let uid = self.sessionStore.session?.uid {
                        self.team[\.owners] = .arrayUnion([uid])
                        self.team[\.members] = .arrayUnion([uid])
                        self.team[\.type] = self.isPrivate ? Team.Model.TeamType.closed.rawValue : Team.Model.TeamType.opened.rawValue
                    }
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
