//
//  SignIn.swift
//  PlantManiac
//
//  Created by ASELab on 24.07.2025..
//

import SwiftUI
import FirebaseAuth

struct SignIn: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var navigateToHome = false
    
    var body: some View {

        NavigationStack{
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            VStack (alignment: .center, spacing: 20) {
                Spacer()
            
                Image( "LogoIcon")
                    .resizable()
                    .frame(width: 100, height:100)
                
                Text(NSLocalizedString("sign_in1", comment: "Prijava korisnika."))
                    .foregroundStyle(.accent)
                    .font(.custom("Georgia-Italic", size: 24))
                    .padding(.bottom, 30)
                
                VStack(spacing: 30){
                    HStack{
                        Image(systemName:"person.fill")
                            .foregroundColor(.gray)
                            
                        // play with the frame and padding here
                        TextField("Username", text: $username)
                            .font(.custom("Georgia", size: 18))
                            .padding(.horizontal,8)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)                    }
                            .padding()
                            .background(Color.white)
                            .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonColor"), lineWidth: 5)
                            .onChange(of: username) { oldValue, newValue in
                                    errorMessage = nil
                                }
                    )
                    .cornerRadius(20)
                    
                    HStack{
                        Image(systemName:"lock.fill")
                            .foregroundStyle(.gray)
                            
                        SecureField("Password", text: $password)
                            .font(.custom("Georgia", size: 18))
                            .padding(.horizontal,8)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)                    }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("ButtonColor"), lineWidth: 5)
                                    )
                            .cornerRadius(20)
                            .onChange(of: password) { oldValue, newValue in
                                    errorMessage = nil
                                }
                    
                    if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                    }

                
                    Button(action: signIn){
                        if isLoading{
                            ProgressView()
                        }else {
                            Text("Sign in")
                                .font(.custom("Georgia", size: 22))
                                .foregroundColor(.accent)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.top, 40)
                    .disabled(isLoading || username.isEmpty || password.isEmpty)
                    
                    
                    .navigationDestination(isPresented: $navigateToHome){
                        HomeView()
                }
                    Spacer()
            }
                .padding()
            }
            
        }
    }
            
    }
    func signIn() {
            isLoading = true
            errorMessage = nil

        AuthService.shared.loginWithUsername(username: username, password: password) { result in
            DispatchQueue.main.async {
                       isLoading = false
            isLoading = false
            
                switch result {
                case .success:
                    print("Login successfull!")
                    navigateToHome = true
                case .failure(let error):
                    print("Error occured in login process: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
        }
        }

    }
}

#Preview {
    SignIn()
}

