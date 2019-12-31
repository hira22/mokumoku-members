//
//  NewTaskView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/30.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import Ballcap

struct NewTaskView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject(initialValue: Task()) var task: Task
    
    @State var teams: [Team] = []
    let dataSource: DataSource<Team>
    @State var selectedTeam: Team!
    
    let user: User
    
    init (user: User) {
        self.user = user
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
                        ForEach(self.teams) { team in
                            Button(team[\.name]) {
                                self.selectedTeam = team
                            }
                        }
                    }
                }
                TextField("今日はなにしよう？", text: self.$task[\.toDo])
                TextField("なんで？", text: self.$task[\.reason])
            }
            .onAppear {
                self.selectedTeam = Team(self.user[\.personalTeamRef])
                self.dataSource
                    .onChanged({ (_, snapshot) in
                        self.teams = snapshot.after
                    })
                    .listen()
            }
            .onDisappear {
                self.dataSource.stop()
            }
            .navigationBarTitle("New task")
            .navigationBarItems(trailing:
                Button("Do it now!") {
                    self.task.save()
                    Task(id: self.task.documentReference.documentID,
                         from: self.task.data!,
                         collectionReference: self.user.documentReference.collection(Task.name))
                        .save()
                    
                    Task(id: self.task.documentReference.documentID,
                         from: self.task.data!,
                         collectionReference: self.selectedTeam.documentReference.collection(Task.name))
                        .save()
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(user: User())
    }
}
