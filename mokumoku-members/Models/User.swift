//
//  User.swift
//  mokumoku-members
//
//  Created by private on 2019/12/24.
//  Copyright © 2019 moca. All rights reserved.
//

import FirebaseFirestore
import Ballcap

final class User: Object, DataRepresentable, DataCacheable, ObservableObject, Identifiable {
    typealias ID = String
    
    override class var name: String { "users" }
    
    @Published var data: User.Model?
    
    struct Model: Modelable, Codable {
        var name: String = ""
        var personalTeamRef: DocumentReference!
    }
    
    var lister: ListenerRegistration?
}
