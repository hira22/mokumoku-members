//
//  SessionStore.swift
//  mokumoku-members
//
//  Created by private on 2019/12/25.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Combine

class SessionStore: ObservableObject {
    @Published var user: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, authUser) in
            guard let authUser = authUser else {
                // if we don't have a user, set our session to nil
                self.user = nil
                return
            }
            
            // if we have a user, create a new user model
            print("Got user: \(authUser)")
            User.get(id: authUser.uid) { (user, error) in
                if let error = error {
                    print("\(#function): \(error)")
                    return
                }
                
                if let user = user {
                    self.user = user
                } else {
                    let team = Team()
                    team[\.name]    = "Personal Team"
                    team[\.members] = .arrayUnion([authUser.uid])
                    team[\.owners]  = .arrayUnion([authUser.uid])
                    team[\.type]    = Team.Model.TeamType.personal.rawValue
                    team.save()
                    
                    self.user = User(id: authUser.uid,
                                     from: User.Model(name: "anonymous",
                                                      personalTeamRef: team.documentReference))
                    
                    self.user?.save()
                }
                
            }

        }
    }
    
    func signInAnonymous(completion: @escaping AuthDataResultCallback) {
        Auth.auth().signInAnonymously(completion: completion)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("\(#function): \(error)")
        }
    }
}

struct Session {
    var uid: String
    var email: String?
    var displayName: String?
    var isAnonymous: Bool
}
