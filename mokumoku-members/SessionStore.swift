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
    @Published var session: Session? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    @Published var user: User?
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = Session(
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName)
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func signInAnonymous(completion: @escaping AuthDataResultCallback) {
        Auth.auth().signInAnonymously(completion: completion)
    }
}

struct Session {
    var uid: String
    var email: String?
    var displayName: String?
}
