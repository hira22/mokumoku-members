//
//  TaskView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/31.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct TaskView: View {
    @State var task: Task
    
    var body: some View {
        NavigationView {
            VStack {
                Text(task[\.toDo])
                Text(task[\.reason])
            }
            .navigationBarTitle(task[\.toDo])
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: Task(id: "test", from: Task.Model(status: .completed,
                                                         completedAt: .pending,
                                                         toDo: "ToDo",
                                                         reason: "Reason",
                                                         done: "Done",
                                                         knowledge: "Knowledge",
                                                         wantToDo: "NextToDo")))
    }
}
