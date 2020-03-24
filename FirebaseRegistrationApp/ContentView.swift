//
//  ContentView.swift
//  FirebaseRegistrationApp
//
//  Created by Gurjit Singh on 24/03/20.
//  Copyright © 2020 Gurjit Singh. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView(email: "", password: "")
        }
    }
}

struct LoginView: View {
    
    @State var email: String
    @State var password: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome!").font(.title)
            Spacer()
            TextField("Email", text: $email)
                .padding(.all, 10)
                .border(Color.yellow, width: 1).cornerRadius(1)
            SecureField("Password", text: $password)
                .padding(.all, 10)
                .border(Color.yellow, width: 1).cornerRadius(1)
            
            Spacer()
            Button(action: {
                //get validation
                let error = self.validationSignIn()
                if error != nil {
                    //show error if have one
                    print("Error \(String(describing: error))")
                } else {
                    //login the user
                }
            }) {
                Text("LOGIN")
            }.padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                .foregroundColor(Color.white)
                .background(Color.yellow)
                .cornerRadius(40)
            Spacer()
            HStack {
                Text("Don't have an Account? ").font(.subheadline)
                NavigationLink(destination: RegistrationView(newName: "", newEmail: "", newPassword: "")) {
                Text("Create Account")
                    .foregroundColor(Color.yellow).font(.headline)
                }
            }
            Spacer()
            } .navigationBarTitle("Sign In")
            .accentColor(Color.yellow)
            .padding(.all,30)
            .navigationBarBackButtonHidden(true)
    }
    
    //check email and password validation
    func validationSignIn() -> String? {
        if email.trimmingCharacters(in: .whitespaces) == "" {
            return "Please fill your email."
        } else if (password.trimmingCharacters(in: .whitespaces) == "") {
            return "Please fill your password."
        } else {
            return nil
        }
    }
}

struct RegistrationView: View {
    
    @State var newName: String
    @State var newEmail: String
    @State var newPassword: String
    
    var body: some View {
        VStack {
            Text("")
            Spacer()
            TextField("Name", text: $newName)
            .padding(.all, 10)
            .border(Color.yellow, width: 1).cornerRadius(1)
            TextField("Email", text: $newEmail)
            .padding(.all, 10)
            .border(Color.yellow, width: 1).cornerRadius(1)
            SecureField("Password", text: $newPassword)
            .padding(.all, 10)
            .border(Color.yellow, width: 1).cornerRadius(1)
            Spacer()
            Button(action: {
                //get validation
                let error = self.validateSignUp()
                if error != nil {
                    print("Error \(String(describing: error))")
                } else {
                    //create new user
                    Auth.auth().createUser(withEmail: self.newEmail, password: self.newPassword) { (result, error) in
                        //check errors
                        if error != nil {
                            print("Error: \(String(describing: error))")
                        } else {
                            //user created successfully
                            
                        }
                    }
                }
            }) {
                Text("Sign Up")
            }.padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                .foregroundColor(Color.white)
                .background(Color.yellow)
                .cornerRadius(40)
            Spacer()
            HStack {
                Text("Already have an Account? ").font(.subheadline)
                NavigationLink(destination: LoginView(email: "", password: "")) {
                Text("Sign In")
                    .foregroundColor(Color.yellow).font(.headline)
                }
            }
            Spacer()
        }.navigationBarTitle("Sign Up")
        .accentColor(Color.yellow)
        .padding(.all,30)
        .navigationBarBackButtonHidden(true)
    }
    
    func validateSignUp() -> String? {
        //validating the name,email and password
        if newName.trimmingCharacters(in: .whitespaces) == "" {
            return "Please fill your name."
        } else if (newEmail.trimmingCharacters(in: .whitespaces) == "") {
            return "Please fill your email."
        } else if (newPassword.trimmingCharacters(in: .whitespaces) == "") {
            return "Please fill your password."
        } else {
            return nil
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Welcome")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
