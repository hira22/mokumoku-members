//
//  Task.swift
//  mokumoku-members
//
//  Created by private on 2019/12/24.
//  Copyright © 2019 moca. All rights reserved.
//

import Ballcap
import FirebaseFirestore

final class Task: Object, DataRepresentable, DataCacheable, ObservableObject, Identifiable {
    typealias ID = String
    
    override class var name: String { "tasks" }
    
    @Published var data: Task.Model?
    
    struct Model: Modelable, Codable {
        var status: Status = .working
        var startAt: Timestamp = Timestamp(date: Date())
        var finishedAt: Timestamp = Timestamp(date: Date())
        
        var toDo: OperableArray<String> = []
        var reason: OperableArray<String> = []
        
        var done: OperableArray<String> = []
        var knowledge: OperableArray<String> = []
        var wantToDo: OperableArray<String> = []
        
        enum Status: String, CaseIterable, Codable {
            case completed
            case working
        }
        
    }
    
    var lister: ListenerRegistration?
}
