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
        var completedAt: ServerTimestamp = .pending
        
        var toDo: String = ""
        var reason: String = ""
        
        var done: String = ""
        var knowledge: String = ""
        var wantToDo: String = ""
        
        enum Status: String, CaseIterable, Codable {
            case completed
            case working
        }
        
    }
    
    var lister: ListenerRegistration?
}
