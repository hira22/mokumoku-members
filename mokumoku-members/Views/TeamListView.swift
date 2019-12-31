//
//  TeamListView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/25.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import Ballcap

struct TeamListView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    @State var teams: [Team] = []
    let dataSource: DataSource<Team>
    @State var isNewTeamViewPresented: Bool = false
    
    init (user: User) {
        dataSource = Team
            .where("members", arrayContains: user.documentReference.documentID )
            .order(by: "updatedAt")
            .limit(to: 30)
            .dataSource()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(teams) { team in
                    NavigationLink(destination: TeamView(team: team)) {
                        Text(team[\.name])
                    }
                }
            }
            .onAppear {
                self.dataSource
                    .onChanged({ (_, snapshot) in
                        self.teams = snapshot.after
                    })
                    .listen()
            }
            .onDisappear {
                self.dataSource.stop()
            }
            .navigationBarItems(trailing:
                Button("NewTeam") {
                    self.isNewTeamViewPresented.toggle()
                }
            )
            .sheet(isPresented: $isNewTeamViewPresented) {
                NewTeamView().environmentObject(self.sessionStore)
            }
        }
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView(user: User())
    }
}
