//
//  TeamEditView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/25.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct TeamEditView: View {
    @State var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var team: Team
    
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
            .navigationBarItems(trailing: Button("save") {
                self.team[\.owners] = .arrayUnion([self.user.id])
                self.team[\.members] = .arrayUnion([self.user.id])
                self.team[\.type] = self.isPrivate ? Team.Model.TeamType.closed.rawValue : Team.Model.TeamType.opened.rawValue
                self.team.save()
                self.presentationMode.wrappedValue.dismiss()
                
            })
        }
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamEditView(user: User(), team: Team())
    }
}
