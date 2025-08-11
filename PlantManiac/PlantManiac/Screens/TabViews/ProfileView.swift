//
//  ProfileView.swift
//  PlantManiac
//
//  Created by ASELab on 28.07.2025..
//

import SwiftUI
import FirebaseAuth
import Combine

struct ProfileView: View {
    
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var errorMessage: String?
    @State private var notificationOn = false
    @State private var showAboutSheet = false
    @State private var showSettingsAlert = false
    
    @ObservedObject var plantsList: PlantListViewModel
    let notifications = UserNotificationsService()
    @State private var cancellable = Set<AnyCancellable>()
    
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = false

    
    var body: some View {
        
        VStack(spacing: 16){
            Text(NSLocalizedString("profile", comment: ""))
                .font(.custom("Georgia-BoldItalic", size: 24))
                .foregroundColor(.accent)
                .frame(alignment: .center)
                .padding([.top, .bottom], 15)
            
            VStack(alignment: .leading, spacing: 16) {
                
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("name_lastname")
                        .font(.custom("Georgia", size: 18))
                    Spacer()
                    Text(name)
                        .font(.custom("Georgia", size: 18))
                }
                
                HStack {
                    Text("username")
                        .font(.custom("Georgia", size: 18))
                    Spacer()
                    Text(username)
                        .font(.custom("Georgia", size: 18))
                }
                
                HStack {
                    Text("plants_saved")
                        .font(.custom("Georgia", size: 18))
                    Spacer()
                    
                    let plantNumber = plantsList.plants.count
                    Text(plantNumber.description)
                        .font(.custom("Georgia", size: 18))
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.button.opacity(1), lineWidth: 3)
                    .padding(10)
            )
            Spacer()
        }
        .padding([.bottom], 25)
        
        
        .onAppear {
            AuthService.shared.fetchUserData { result in
                switch result {
                case .success(let (fetchedName, fetchedUsername)):
                    self.name = fetchedName
                    self.username = fetchedUsername
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
            
            AuthService.shared.fetchNotificationsPreference()
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Greška: \(error.localizedDescription)")
                        self.notificationOn = false
                    }
                }, receiveValue: { enabled in
                    self.notificationOn = enabled
                })
                .store(in: &cancellable)
        }

        
        VStack(spacing: 10) {
            HStack {
                Text("notifications")
                    .font(.custom("Georgia", size: 18))
                    .foregroundColor(.accent)
                Spacer()
                Toggle("", isOn: $notificationOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .accent))
                
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color("ButtonColor"))
            .cornerRadius(20)
            .onChange(of: notificationOn) { _, newValue in
                if newValue {
                    notifications.requestNotificationPermission { granted in
                        if !granted {
                            showSettingsAlert = true
                            notificationOn = false
                            return
                        }
                    }
                }
                
                AuthService.shared.updateNotificationsPreference(enabled: newValue) { error in
                        if let error = error {
                            print("Greška pri ažuriranju notifikacija: \(error.localizedDescription)")
                        } else {
                            print("Notifikacije ažurirane na: \(newValue)")
                        }
                    }
            }
                
                Button(action: {
                    showAboutSheet = true
                }) {
                    Text("app_about")
                        .font(.custom("Georgia", size: 18))
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(minHeight: 50)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
                .sheet(isPresented: $showAboutSheet) {
                    AboutAppView()
                }
                
                Button(action: {
                    AuthService.shared.logout { result in
                        switch result {
                        case .success():
                            print("Uspješno odjavljeno")
                            isUserLoggedIn = false
                        case .failure(let error):
                            print("Logout error: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("sign_out")
                        .font(.custom("Georgia", size: 18))
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(minHeight: 50)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
            .alert("notifications_denied",
                   isPresented: $showSettingsAlert,
                   actions: {
                Button("open_settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("cancel", role: .cancel) {}
            },
                   message: {
                Text("text_enable_notifications")
            }
            )
            
        }
    }
    

