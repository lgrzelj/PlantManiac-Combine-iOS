//
//  SignIn.swift
//  PlantManiac
//
//  Created by ASELab on 24.07.2025..
//

import SwiftUI

struct SignIn: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {

        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            VStack (alignment: .center, spacing: 20) {
                Spacer()
            
                Image( "LogoIcon")
                    .resizable()
                    .frame(width: 100, height:100)
                
                Text("Sign in!")
                    .foregroundStyle(.accent)
                    .font(.custom("Itim", size: 24))
                    .padding(.bottom, 30)
                
                VStack(spacing: 30){
                    HStack{
                        Image(systemName:"person.fill")
                            .foregroundColor(.gray)
                            
                        // play with the frame and padding here
                        TextField("Username", text: $username)
                            .font(.custom("Itim", size: 18))
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
                        Image(systemName:"lock.fill")
                            .foregroundStyle(.gray)
                            
                        SecureField("Password", text: $password)
                            .font(.custom("Itim", size: 18))
                            .padding(.horizontal,8)

                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("ButtonColor"), lineWidth: 5)
                        )
                    .cornerRadius(20)
                
                Button(action:{}){
                                Text("Sign in")
                        .font(.custom("Itim", size: 20))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(20)
                            }
                            .padding(.horizontal, 50)
                            .padding(.top, 40)
                    
                    Spacer()
            }
                .padding()
            }
            
        }
        
        
    }
}

#Preview {
    SignIn()
}
