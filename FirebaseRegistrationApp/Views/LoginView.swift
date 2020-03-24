//
//  LoginView.swift
//  FirebaseRegistrationApp
//
//  Created by Gurjit Singh on 24/03/20.
//  Copyright © 2020 Gurjit Singh. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String
    @State var password: String
    
    var body: some View {
        VStack {
            TextField("", text: $email)
            TextField("", text: $password)
        }
    }
}
