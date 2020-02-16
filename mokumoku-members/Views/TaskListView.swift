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
    var user: User
    @State var tasks: [Task] = []
    let dataSource: DataSource<Task>
    
    enum Presentation: View, Hashable, Identifiable {
        case new(user: User)
        case edit(user: User, task: Task)
        
        var id: Self { self }
        var body: some View {
            switch self {
            case .new(let user):            return TaskEditView(user: user)
            case .edit(let user, let task): return TaskEditView(user: user, task: task)
            }
        }
    }
    
    @State var presentation: Presentation?
    
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
                    VStack {
                        Text(task[\.toDo])
                    }.contextMenu {
                        Button("Edit") {
                            self.presentation = .edit(user: self.user, task: task.copy())
                        }
                    }
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
            .sheet(item: $presentation, content: {$0})
            .navigationBarItems(trailing: Button("New") {
                self.presentation = .new(user: self.user)
            })
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(user: User())
    }
}

//extension Identifiable where Self: Hashable {
//    typealias ID = Self
//    var id: Self { self }
//}
