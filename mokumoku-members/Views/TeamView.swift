//
//  TeamView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/28.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import Ballcap

struct TeamView: View {
    var team: Team
    
    var dataSource: DataSource<Task>
    @State var tasks: [Task] = []
    
    init(team: Team) {
        self.team = team
        dataSource = DataSource<Task>
            .Query(team.documentReference.collection("tasks"))
            .dataSource()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    Text(task.data?.toDo.first ?? "")
                }
            }
        }.onAppear {
            self.dataSource
                .onChanged({ (_, snapshot) in
                    self.tasks = snapshot.after
                })
                .listen()
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(team: Team())
    }
}
