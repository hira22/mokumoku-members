//
//  AuthView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/25.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct AuthView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: SessionStore
    
    @State var isAlertShow: Bool = false
    @State var error: Error?
    
    var body: some View {
        VStack {
            Button(action: {
                self.session.signInAnonymous { (result, error) in
                    if let error = error {
                        self.error = error
                        self.isAlertShow = true
                        return
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }, label: {
                Text("Anonymous Sign In")
            }).alert(isPresented: $isAlertShow) {
                Alert(title: Text(error.debugDescription))
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(SessionStore())
    }
}
