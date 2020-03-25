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
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView(email: "", password: "",errorMessage: "")
        }
    }
}

struct LoginView: View {
    
    @State var email: String
    @State var password: String
    @State var errorMessage: String
    @State var isLogin = false
    
    var body: some View {
        VStack {
            Text("Welcome!").font(.title)
            Spacer()
            Text(errorMessage).font(.subheadline).foregroundColor(Color.red)
            TextField("Email", text: $email)
                .padding(.all, 10)
                .border(Color.yellow, width: 1).cornerRadius(1)
            SecureField("Password", text: $password)
                .padding(.all, 10)
                .border(Color.yellow, width: 1).cornerRadius(1)
            
            Spacer()
            NavigationLink(destination: HomeView(), isActive: $isLogin) {
            Button(action: {
                //get validation
                let error = self.validationSignIn()
                if error != nil {
                    //show error if have one
                    print("Error \(String(describing: error))")
                    self.errorMessage = error ?? "Unknown"
                } else {
                    //login the user
                    Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                        if error != nil {
                            print("Error while Sign In.")
                            self.errorMessage = "* Wrong email or password."
                        } else {
                            //Sign in successful
                            print("Login Successfully.")
                            self.isLogin.toggle()
                        }
                    }
                    
                }
            }) {
                Text("LOGIN")
            }
            .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                .foregroundColor(Color.white)
                .background(Color.yellow)
                .cornerRadius(40)
            }
            Spacer()
            HStack {
                Text("Don't have an Account? ").font(.subheadline)
                NavigationLink(destination: RegistrationView(newName: "", newEmail: "", newPassword: "", errorMessage: "")) {
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
            return "* Please fill your email."
        } else if (password.trimmingCharacters(in: .whitespaces) == "") {
            return "* Please fill your password."
        } else {
            return nil
        }
    }
}

struct RegistrationView: View {
    
    @State var newName: String
    @State var newEmail: String
    @State var newPassword: String
    @State var errorMessage = ""
    @State var isSignup = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(errorMessage).foregroundColor(Color.red).font(.subheadline)
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
            
            NavigationLink(destination: HomeView(), isActive: $isSignup) {
            Button(action: {
                //get validation
                let error = self.validateSignUp()
                if error != nil {
                    self.errorMessage = error ?? "Unknown"
                } else {
                    //create new user
                    Auth.auth().createUser(withEmail: self.newEmail, password: self.newPassword) { (result, error) in
                        //check errors
                        if error != nil {
                            print("Error found while creating new user.")
                        } else {
                            //user created successfully
                            let database = Firestore.firestore()
                            database.collection("users").addDocument(data: ["name": self.newName, "uid": result!.user.uid ]) { error in
                                    //check errors
                                if error != nil {
                                    //self.errorMessage = error as! String
                                    print("Error found while creating name.")
                                }
                            }
                            
                            //navigate user to home screen
                            print("Sign Up successfull")
                            self.isSignup = true
                            
                        }
                    }
                }
            }) {
                Text("Sign Up")
            }.padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                .foregroundColor(Color.white)
                .background(Color.yellow)
                .cornerRadius(40)
            }
            Spacer()
            HStack {
                Text("Already have an Account? ").font(.subheadline)
                NavigationLink(destination: LoginView(email: "", password: "",errorMessage: "")) {
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
            return "* Please fill your name."
        } else if (newEmail.trimmingCharacters(in: .whitespaces) == "") {
            return "* Please fill your email."
        } else if (newPassword.trimmingCharacters(in: .whitespaces) == "") {
            return "* Please fill your password."
        } else {
            return nil
        }
    }
}

struct HomeView: View {
    
    @State var isSignout = false
    
    var body: some View {
        VStack {
            Text("Welcome!")
        }
    .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            NavigationLink(destination: LoginView(email: "", password: "", errorMessage: ""), isActive: $isSignout) {
            Button(action: {
                //Sign out user
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.isSignout.toggle()
                } catch {
                    print("Error while signing out.")
                }
            }) {
                Text("Sign out")
                }}
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
