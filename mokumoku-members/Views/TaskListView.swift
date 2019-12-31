//
//  TaskListView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/31.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import Ballcap

struct TaskListView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var user: User
    @State var tasks: [Task] = []
    let dataSource: DataSource<Task>
    @State var isNewTaskViewPresented: Bool = false
    
    init (user: User) {
        self.user = user
        self.dataSource = DataSource<Task>
            .Query(user.documentReference.collection(Task.name))
            .order(by: "updatedAt")
            .limit(to: 30)
            .dataSource()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
//                    NavigationLink(destination: TeamView(team: team)) {
                        Text(task[\.toDo])
//                    }
                }
            }
            .onAppear {
                self.dataSource
                    .onChanged({ (_, snapshot) in
                        self.tasks = snapshot.after
                    })
                    .listen()
            }
            .onDisappear {
                self.dataSource.stop()
            }
            .sheet(isPresented: $isNewTaskViewPresented) {
                NewTaskView(user: self.user)
            }
            .navigationBarItems(trailing:
                Button("NewTask") {
                    self.isNewTaskViewPresented.toggle()
                }
            )
            
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(user: User())
    }
}
