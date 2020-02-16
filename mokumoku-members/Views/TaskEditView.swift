//
//  TaskEditView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/30.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import Ballcap

struct TaskEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var task: Task
    
    @State var teams: [Team] = []
    let dataSource: DataSource<Team>
    @State var selectedTeam: Team = Team()
    
    let user: User
    
    init (user: User, task: Task = Task()) {
        self.user = user
        self.task = task
        self.dataSource = Team
            .where("members", arrayContains: user.documentReference.documentID)
            .order(by: "updatedAt")
            .limit(to: 30)
            .dataSource()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(self.teams.reversed()) { team in
                            if team == self.selectedTeam {
                                Button(action: { self.selectedTeam = team },
                                   label: {
                                    Text(team[\.name])
                                        .fontWeight(.bold)
                                        .font(.body)
                                    .padding()
                                        .background(Color.red)
                                        .cornerRadius(30)
                                        .foregroundColor(.white) })
                                .padding()
                            } else {
                            
                            Button(action: { self.selectedTeam = team },
                                   label: {
                                    Text(team[\.name])
                                        .fontWeight(.bold)
                                        .font(.body)
                                    .padding()
                                        .background(Color.blue)
                                        .cornerRadius(30)
                                        .foregroundColor(.white) })
                                .padding()
                            }
                            
                        }
                    }
                }
                TextField("What to do today？", text: self.$task[\.toDo])
                TextField("What for？", text: self.$task[\.reason])
            }
            .onAppear {
                self.selectedTeam = self.user.personalTeam!
                self.dataSource
                    .onChanged({ (_, snapshot) in
                        self.teams = snapshot.after
                    })
                    .listen()
            }
            .onDisappear {
                self.dataSource.stop()
            }
            .navigationBarItems(trailing: Button("Do it now!") {
                self.task.save()
                Task(id: self.task.id,
                     from: self.task.data!,
                     collectionReference: self.user.documentReference.collection(Task.name))
                    .save()
                
                Task(id: self.task.id,
                     from: self.task.data!,
                     collectionReference: self.selectedTeam.documentReference.collection(Task.name))
                    .save()
                
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(user: User())
    }
}
