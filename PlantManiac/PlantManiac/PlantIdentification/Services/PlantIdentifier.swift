import Foundation
import UIKit

class PlantIdentifier: ObservableObject {
    
    @Published var resultText: String = ""
    @Published var isLoading: Bool = false
    @Published var plantDetails: PlantDetailsModel?
    
    private let wikiFetcher = FetchingDataFromWiki()
    let apiKey = "DI05PI7jTvqqCoerMEH04CkEx2MOMNJpanGoMBIkBzUNKCEjk5"
    
    // Automatska identifikacija biljke
    func identifyPlant(image: UIImage) {
        self.resultText = ""
        self.isLoading = true
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            DispatchQueue.main.async {
                self.resultText = "error_image"
                self.isLoading = false
            }
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        guard let url = URL(string: "https://api.plant.id/v2/identify") else {
            DispatchQueue.main.async {
                self.resultText = "error_url"
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
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            DispatchQueue.main.async {
                self.resultText = NSLocalizedString("error_id_plant", comment: "")
                self.isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                self.updateWithError(NSLocalizedString("no_id_plant", comment:""))
                return
            }
            self.processIdentificationResponse(data, userImage: image)
        }.resume()
    }
    
    private func processIdentificationResponse(_ data: Data, userImage: UIImage) {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let suggestions = json["suggestions"] as? [[String: Any]],
            let first = suggestions.first,
            let name = first["plant_name"] as? String,
            let probability = first["probability"] as? Double,
            let details = first["plant_details"] as? [String: Any]
        else {
            updateWithError("no_id_plant")
            return
        }

        let commonNames = details["common_names"] as? [String] ?? []

        self.fetchPlantDetails(for: name, probability: probability, commonNames: commonNames, details: details, userImageSelected: userImage)

        DispatchQueue.main.async {
            self.resultText = "Biljka: \(name)\nVjerojatnost: \(Int(probability * 100))%"
        }
    }
    
    func fetchPlantDetails(
        for name: String,
        probability: Double,
        commonNames: [String],
        details: [String: Any],
        userImageSelected: UIImage?
    ) {
        let fallbackSummary = (details["wiki_description"] as? [String: Any])?["value"] as? String ?? "Currently not available."
        let fallbackDescription = fallbackSummary
        let sunlight = details["sunlight"] as? [String] ?? ["Bright, indirect light"]
        let watering = details["watering"] as? String ?? "2-3x week"
        
        let careLevel = Int.random(in: 1...5)
        let temperature = "18°C - 24°C"
        let humidity = "50%"
        let price = Double.random(in: 10...40)
        
        wikiFetcher.fetchSummary(for: name) { summaryText in
            let summary = summaryText ?? fallbackSummary
            
            self.wikiFetcher.fetchWikidataID(for: name) { qid in
                guard let qid = qid else {
                    self.updatePlantDetails(
                        name: name,
                        probability: probability,
                        commonNames: commonNames,
                        description: fallbackDescription,
                        summary: summary,
                        sunlight: sunlight,
                        watering: watering,
                        temperature: temperature,
                        humidity: humidity,
                        careLevel: careLevel,
                        price: price,
                        plantImage: userImageSelected
                    )
                    return
                }
                
                self.wikiFetcher.fetchStructuredData(for: qid) { claims in
                    let wikidataDescription = self.wikiFetcher.extractValue(from: claims["P279"]) ?? fallbackDescription
                    let newTemperature = self.wikiFetcher.extractValue(from: claims["P2284"])
                    let finalTemperature = newTemperature ?? temperature
                    
                    self.updatePlantDetails(
                        name: name,
                        probability: probability,
                        commonNames: commonNames,
                        description: wikidataDescription,
                        summary: summary,
                        sunlight: sunlight,
                        watering: watering,
                        temperature: finalTemperature,
                        humidity: humidity,
                        careLevel: careLevel,
                        price: price,
                        plantImage: userImageSelected
                    )
                }
            }
        }
    }
    
    private func updatePlantDetails(
        name: String,
        probability: Double,
        commonNames: [String],
        description: String,
        summary: String,
        sunlight: [String],
        watering: String,
        temperature: String,
        humidity: String,
        careLevel: Int,
        price: Double,
        plantImage: UIImage?
    ) {
        DispatchQueue.main.async {
            self.plantDetails = PlantDetailsModel(
                name: name,
                probability: Int(probability * 100),
                commonNames: commonNames,
                description: description,
                summary: summary,
                watering: watering,
                sunlight: sunlight,
                temperature: temperature,
                humidity: humidity,
                careLevel: careLevel,
                price: String(format: "%.2f", price),
                plantImage: plantImage,
                imageUrl: nil
            )
            self.isLoading = false
        }
    }
    
    private func updateWithError(_ message: String) {
        DispatchQueue.main.async {
            self.resultText = message
            self.isLoading = false
        }
    }
}
