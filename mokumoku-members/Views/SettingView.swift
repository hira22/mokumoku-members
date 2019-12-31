//
//  SettingView.swift
//  mokumoku-members
//
//  Created by private on 2019/12/31.
//  Copyright © 2019 moca. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var isAlertShow: Bool = false
    @State var error: Error?
    
    var body: some View {
        VStack {
            Button(action: {
                self.session.signOut()
            }, label: {
                Text("Sign Out")
            }).alert(isPresented: $isAlertShow) {
                Alert(title: Text(error.debugDescription))
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
