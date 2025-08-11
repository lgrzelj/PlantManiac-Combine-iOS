//
//  Registration.swift
//  PlantManiac
//
//  Created by ASELab on 27.07.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct Registration: View {
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isUsernameAvailable: Bool? = nil
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var registrationSuccess = false
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
                
                Text(NSLocalizedString("registration1", comment: "Registracija korisnika."))
                    .foregroundStyle(.accent)
                    .font(.custom("Georgia-Italic", size: 24))
                    .padding(.bottom, 30)
            
                VStack(spacing: 30){
                    HStack{
                        Image("Email")
                            .foregroundColor(.gray)
                        
                        // play with the frame and padding here
                        TextField("Email", text: $email)
                            .font(.custom("Georgia", size: 18))
                            .padding(.horizontal,8)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonColor"), lineWidth: 5)
                    )
                    .cornerRadius(20)
                    
                    HStack{
                        Image(systemName:"person.fill")
                            .foregroundColor(.gray)
                        
                        // play with the frame and padding here
                        TextField(NSLocalizedString("name_lastname", comment: "Korisnikovo ime i prezime"), text: $name)
                            .autocapitalization(.none)
                            .font(.custom("Georgia", size: 18))
                            .padding(.horizontal,8)
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ButtonColor"), lineWidth: 5)
                    )
                    .cornerRadius(20)
                    
                    HStack{
                        Image(systemName:"person.fill")
                            .foregroundColor(.gray)
                        
                        // play with the frame and padding here
                        TextField(NSLocalizedString("username", comment: "Korisničko ime." ), text: $username)
                            .font(.custom("Georgia", size: 18))
                            .padding(.horizontal,8)
                            .autocapitalization(.none)
                            .onChange(of: username) { newUsername in
                                        AuthService.shared.checkUsernameAvailability(newUsername) { isAvailable in
                                            DispatchQueue.main.async {
                                                self.isUsernameAvailable = isAvailable
                                            }
                                        }
                            }
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color("ButtonColor"), lineWidth: 5)
                    )
                    .cornerRadius(20)
                    
                    if let available = isUsernameAvailable {
                        Text(available ? NSLocalizedString("username_available", comment:"") : NSLocalizedString("username_exists", comment: ""))

                            .foregroundColor(available ? .green : .red)
                            .font(.custom("Georgia", size: 10))
                    }
                    
                    HStack{
                        Image(systemName:"lock.fill")
                                .foregroundStyle(.gray)
                                    
                        SecureField(NSLocalizedString("password", comment: "Lozinka"), text: $password)
                                .font(.custom("Georgia", size: 18))
                                .padding(.horizontal,8)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("ButtonColor"), lineWidth: 5)
                        )
                        .cornerRadius(20)
                        
                        if password.count > 0 && password.count < 6 {
                            Text(NSLocalizedString("password_requirement" , comment:""))
                                        .foregroundColor(.red)
                                        .font(.custom("Georgia", size: 10))
                        }
                        
                    if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                    }
                                
                        Button(action: registration)
                        {
                            if isLoading{
                                ProgressView()
                            } else {
                                Text(NSLocalizedString("registration", comment: "Registracija korisnika."))
                                    .font (.custom("Georgia", size: 22))
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(20)
                                    }
                                }
                                .padding(.horizontal, 50)
                                .padding(.top, 40)
                                .navigationDestination(isPresented: $navigateToHome){
                                    HomeView(plantsList: PlantListViewModel())
                                }
                                                       
                                if registrationSuccess {
                                    Text(NSLocalizedString("registration_success", comment:""))
                                        .foregroundColor(.green)
                                        .font(.custom("Georgia", size: 10))
                                }
                                Spacer()
                            }
                            .padding()
                    }
            }
        }
    }
    
    func registration(){
            isLoading = true
            errorMessage = nil
            
            AuthService.shared.register(email: email, name: name, username: username, password: password) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success:
                        registrationSuccess = true
                        navigateToHome = true
                        print("Registration successfull!")
                        
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        print("Error occured while registration process: \(error.localizedDescription)")
                    }
                }
            }
        }
}

#Preview {
    Registration()
}
