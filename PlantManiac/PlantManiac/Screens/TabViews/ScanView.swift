//
//  ScanView.swift
//  PlantManiac
//
//  Created by ASELab on 28.07.2025..
//

import SwiftUI

struct ScanView: View {
    
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showSourceSelection = false
    @State private var image: UIImage? = nil
    @StateObject private var plantIdentifier = PlantIdentifier()
    
    var body: some View {
        
        
        ZStack{
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            ScrollView{
                
                VStack {
                    
                    Text(NSLocalizedString("scan", comment: ""))
                        .font(.custom("Georgia-BoldItalic", size: 28))
                        .foregroundColor(.accentColor)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                            .cornerRadius(12)
                            .padding()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 400)
                            .overlay(Text(NSLocalizedString("no_picture", comment: "")).foregroundColor(.gray))
                            .cornerRadius(12)
                            .padding()
                    }
                    
                    Text(plantIdentifier.resultText)
                        .font(.custom("Georgia", size: 18))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if plantIdentifier.isLoading {
                        ProgressView(NSLocalizedString("loading", comment: ""))
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(1.4)
                            .padding()
                    } else if !plantIdentifier.resultText.isEmpty {
                        Text(plantIdentifier.resultText)
                            .font(.custom("Georgia", size: 18))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    
                    
                    Button( action: {
                        showSourceSelection = true
                    }){
                        Text(NSLocalizedString("add_picture", comment: ""))
                            .font(.custom("Georgia", size: 20))
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("ButtonColor"))
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 50)
                    .padding()
                    
                    Spacer()
                }
                
                
                .confirmationDialog(NSLocalizedString("options", comment: ""), isPresented: $showSourceSelection) {
                    Button("Take picture") {
                        sourceType = .camera
                        showImagePicker = true
                    }
                    Button(NSLocalizedString("gallery", comment: "")) {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                    Button(NSLocalizedString("quit", comment: ""), role: .cancel) {}
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    if let image = image{
                        plantIdentifier.identifyPlant(image: image)
                        
                    }
                }) {
                    ImagePicker(sourceType: sourceType, selectedImage: $image)
                }
            }
        }
        
    }
}


#Preview {
    ScanView()
}
