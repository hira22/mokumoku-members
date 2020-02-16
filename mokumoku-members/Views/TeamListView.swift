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
    var user: User
    
    @State var teams: [Team] = []
    let dataSource: DataSource<Team>
    
    enum Presentation: View, Hashable, Identifiable {
        case new(user: User)
        case edit(user: User, team: Team)
        
        var id: Self { self }
        var body: some View {
            switch self {
            case .new(let user):            return TeamEditView(user: user, team: Team())
            case .edit(let user, let team): return TeamEditView(user: user, team: team.copy())
            }
        }
    }
    
    @State var presentation: Presentation?
    
    init (user: User) {
        self.user = user
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
                            .contextMenu{
                                Button("Edit") {
                                    self.presentation = .edit(user: self.user, team: team)
                                }
                        }
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
                Button("New") {
                    self.presentation = .new(user: self.user)
                }
            ).sheet(item: $presentation) {$0}
        }
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView(user: User())
    }
}
