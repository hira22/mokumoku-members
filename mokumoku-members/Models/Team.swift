//
//  Team.swift
//  mokumoku-members
//
//  Created by private on 2019/12/24.
//  Copyright © 2019 moca. All rights reserved.
//

import Ballcap
import FirebaseFirestore

final class Team: Object, DataRepresentable, DataCacheable, ObservableObject, Identifiable {
    typealias ID = String
    
    override class var name: String { "teams" }
    
    @Published var data: Team.Model?
    
    struct Model: Modelable, Codable {
        var name: String = ""
        var members: OperableArray<String> = []
        var owners: OperableArray<String> = []
        var type: String = ""
        
        enum TeamType: String {
            case personal
            case opened
            case closed
        }
        
        
    }
    
    var lister: ListenerRegistration?
}
