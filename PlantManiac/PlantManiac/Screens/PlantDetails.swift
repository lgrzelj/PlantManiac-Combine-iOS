//
//  PlantDetailsView.swift
//  PlantManiac
//
//  Created by ASELab on 01.08.2025..
//

import SwiftUI

struct PlantDetails: View {
    
    var plant: PlantDetailsModel
    @State private var showSaveAlert = false

    
    var body: some View {
        ZStack {
            
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            
            VStack(spacing: 20){
                Text("plant_info")
                    .font(.custom("Georgia-BoldItalic", size: 24))
                    .foregroundColor(.accent)
                    .padding(20)
                    .padding(.top, 10)
                
                Text(plant.name)
                    .font(.custom("Georgia-Italic", size: 18))
                    .foregroundColor(.accent)
                    .textCase(.uppercase)
                
                VStack(spacing: 0){
                    
                    HStack (alignment: .top, spacing: 20){
                        
                        if let image = plant.plantImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .cornerRadius(12)
                            
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 150, height: 200)
                                .overlay(Text ("no_picture").foregroundColor(.gray))
                                .cornerRadius(12).padding(5)
                        }
                            
                        VStack(alignment: .leading, spacing: 10){
                            
                            Text("care_level")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .textCase(.uppercase)

                            HStack(spacing: 5) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < plant.careLevel ? "star.fill" : "star")
                                        .font(.system(size: 24))
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding([.bottom,.top], 5)
                            
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.yellow)
                                Text(plant.sunlight.joined(separator: ", "))
                                    .textCase(.uppercase)
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                   
                            }
                            .padding([.bottom,.top], 5)

                            
                            HStack (spacing: 10){
                                Image("HumidityLevel")
                                
                                
                                Text(plant.humidity)
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                
                                Image( "Thermometer")
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 5)
                                
                                Text(plant.temperature)
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        Text("description")
                            .textCase(.uppercase)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accent)
                        
                        ScrollView{
                            Text(plant.description)
                                                        .font(.custom("Georgia", size: 16))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 90)
                        
                        Text("summary")
                            .textCase(.uppercase)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.accent)
                        
                        ScrollView{
                            Text(plant.summary)
                                                        .font(.custom("Georgia", size: 16))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 90)
                            
                       
                        Text("price_range")
                                                        .font(.custom("Georgia", size: 16))
                                                        .foregroundColor(.accent)
                                                        .textCase(.uppercase)

                        HStack (spacing: 10){
                            
                            Image("Price")
                                .frame(width: 24, height: 24)
                            
                            Text(plant.price)
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(.accent)
                            
                            Spacer()
                            Button(action: {
                                if let image = plant.plantImage {
                                     uploadImageToImgBB(image: image) { result in
                                        switch result {
                                        case .success(let url):
                                            showSaveAlert = true;          print(" Slika uploadana: \(url)")
            savePlantToFirestore(plant: plant, imageUrl: url) { error in
                                                if let error = error {
                                                    print(" Greška pri spremanju: \(error.localizedDescription)")
                                                } else {
                                                    print(" Biljka uspješno spremljena s ImgBB URL-om!")
                                                }
                                            }
                                        case .failure(let error):
                                            print(" Greška pri uploadu slike: \(error.localizedDescription)")
                                        }
                                    }}}
                                    ){
                            Text("save_plant")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .textCase(.uppercase)
                            }
                            .padding()
                            .background(Color("ButtonColor"))
                            .frame(height: 40)
                            .cornerRadius(20)
                            
                            Button(action: {}){
                            Text("buy_now")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(.accent)
                                    .textCase(.uppercase)
                            }
                            .padding()
                            .background(Color("ButtonColor"))
                            .frame(height: 40)
                            .cornerRadius(20)
                            
                        }
                        .padding(5)
                        
                    }
                    .padding()
                    .padding(.top, 10)
                    
                    .alert(isPresented: $showSaveAlert) {
                        Alert(
                            title: Text("🌱 Biljka spremljena!"),
                            message: Text("Biljka je uspješno dodana u tvoju kolekciju."),
                            dismissButton: .default(Text("U redu"))
                        )
                    }
                   
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
    let plant = PlantDetailsModel(
        name: "Monstera deliciosa",
        probability: 3,
        commonNames: ["Monstera deliciosa1", "Monstera deliciosa2"],
        description: "Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa, Monstera deliciosa",
        summary: "Summary......",
        watering: "3-4",
        sunlight: ["Bright", "indirect light"],
        temperature: "50",
        humidity: "50%",
        careLevel: 4,
        price: "40",
        plantImage: nil
    )
    PlantDetails(plant: plant)
}
