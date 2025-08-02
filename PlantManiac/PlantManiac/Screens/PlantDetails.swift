//
//  PlantDetailsView.swift
//  PlantManiac
//
//  Created by ASELab on 01.08.2025..
//

import SwiftUI

struct PlantDetails: View {
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            
            VStack(spacing: 20){
                Text(NSLocalizedString("plant_info", comment:""))
                    .font(.custom("Georgia-BoldItalic", size: 24))
                    .foregroundColor(.accent)
                    .edgesIgnoringSafeArea(.top)
                    .padding(25)
                
                Text("Name of the plant")
                    .font(.custom("Georgia-Italic", size: 18))
                    .foregroundColor(.accent)
                    .textCase(.uppercase)
                
                VStack(spacing: 0){
                    
                    HStack (alignment: .top, spacing: 20){
                        
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .cornerRadius(12)
                            
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 200)
                                .overlay(Text(NSLocalizedString("no_picture", comment: "")).foregroundColor(.gray))
                                .cornerRadius(12).padding(5)
                        }
                            
                        VStack(alignment: .leading, spacing: 10){
                            
                            Text(NSLocalizedString("care_level", comment: ""))
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .textCase(.uppercase)

                            HStack(spacing: 5) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < 3 ? "star.fill" : "star")
                                        .font(.system(size: 24))
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding([.bottom,.top], 5)
                            
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.yellow)
                                Text("Bright, indirect light")
                                    .textCase(.uppercase)
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                   
                            }
                            .padding([.bottom,.top], 5)

                            
                            HStack (spacing: 10){
                                Image("HumidityLevel")
                                
                                
                                Text("60%")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                
                                Image( "Thermometer")
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 5)
                                
                                Text("18–27°C")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        Text("Description")
                            .textCase(.uppercase)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accent)
                        
                        Text("Description of description")
                            .font(.custom("Georgia", size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            
                        Text("Summary")
                            .textCase(.uppercase)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accent)
                        
                        Text("Summary of summary")
                            .font(.custom("Georgia", size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                        
                        Text("Price range")
                                                        .font(.custom("Georgia", size: 16))
                                                        .foregroundColor(.accent)
                                                        .textCase(.uppercase)

                        HStack (spacing: 10){
                            
                            Image("Price")
                                .frame(width: 24, height: 24)
                            
                            Text("20-100$")
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(.accent)
                            
                            Spacer(minLength: 0)
                            Button(action: {}){
                            Text("Buy now")
                                    .font(.custom("Georgia", size: 18))
                                    .foregroundColor(.accent)
                                    .textCase(.uppercase)
                            }
                            .padding()
                            .background(Color("ButtonColor"))
                            .frame(width: .infinity, height: 40)
                            .cornerRadius(20)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(5)
                        
                    }
                    .padding()
                   
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.button, lineWidth: 2.5)
                        .padding(.horizontal, 15)
                )
                
                
            }
            .padding(.bottom,80)
        }
    }
}

#Preview {
    PlantDetails()
}
