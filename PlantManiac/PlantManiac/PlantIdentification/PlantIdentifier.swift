//
//  PlantIdentifier.swift
//  PlantManiac
//
//  Created by ASELab on 30.07.2025..
//

import Foundation
import UIKit

class PlantIdentifier: ObservableObject{
    
    
    @Published var resultText: String = ""
    @Published var isLoading: Bool = false
    
    @Published var plantDetails: PlantDetailsModel?

    let apiKey = "HIeIhpXVcj9aveaD52U49zcQ1GW0zR68eJlVhwGWDs0LkzZaA7"
    
    func identifyPlant(image: UIImage) {
        
        self.resultText = ""
        self.isLoading = true
              
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {DispatchQueue.main.async {
            self.resultText = "Greška kod obrade slike."
            self.isLoading = false
        }
        return
    }
        let base64Image = imageData.base64EncodedString()
        
        guard let url = URL(string: "https://api.plant.id/v2/identify") else {
            DispatchQueue.main.async {
                           self.resultText = "Nevažeći URL."
                           self.isLoading = false
                       }
                       return
        }
        
        let payload: [String: Any] = [
            "images": [base64Image],
            "organs": ["leaf"]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("JSON error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let suggestions = json["suggestions"] as? [[String: Any]],
                   let first = suggestions.first,
                   let name = first["plant_name"] as? String,
                   let probability = first["probability"] as? Double,
                   let details = first["plant_details"] as? [String: Any] {
                                   
                        let commonNames = details["common_names"] as? [String] ?? []
                        let description = (details["wiki_description"] as? [String: Any])?["value"] as? String ?? "Nema opisa."
                        let sunlight = details["sunlight"] as? [String] ?? ["Nepoznato"]
                        let watering = details["watering"] as? String ?? "Nepoznato"
                                   
                        // Ostali podaci (simulirani ako nisu u API-ju)
                        let careLevel = Int.random(in: 1...5)
                        let temperature = "18°C - 24°C"
                        let humidity = "50%"
                        let price = Double.random(in: 10...40)
                    
                    DispatchQueue.main.async {
                        self.resultText = "Biljka: (\(name)\n Vjerojatnost: \(Int(probability*100))%"
                        
                        self.plantDetails = PlantDetailsModel(
                                name: name,
                                probability: Int(probability * 100),
                                commonNames: commonNames,
                                description: description,
                                watering: watering,
                                sunlight: sunlight,
                                temperature: temperature,
                                humidity: humidity,
                                careLevel: careLevel,
                                price: price
                            )

                            self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.resultText = NSLocalizedString("no_id_plant", comment: "")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.resultText = NSLocalizedString("error_id_plant", comment: "") 
                }
            }
        }.resume()
    }
  
}
