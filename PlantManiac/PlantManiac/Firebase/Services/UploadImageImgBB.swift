//
//  UploadImageImgBB.swift
//  PlantManiac
//
//  Created by ASELab on 04.08.2025..
//

import Foundation
import UIKit

func uploadImageToImgBB(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.7) else {
        completion(.failure(NSError(domain: "imgbb", code: 0, userInfo: [NSLocalizedDescriptionKey: "Greška kod kompresije slike."])))
        return
    }

    let apiKey = "94e8d5843e7181ec550125de1e73371d"
    let url = URL(string: "https://api.imgbb.com/1/upload?key=\(apiKey)")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()

    // Dodaj sliku kao binarni file
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"plant.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "imgbb", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nema odgovora."])))
            return
        }

        do {

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dataDict = json["data"] as? [String: Any],
               let imageUrl = dataDict["url"] as? String {
                completion(.success(imageUrl))
            } else {
                completion(.failure(NSError(domain: "imgbb", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nepotpuni JSON odgovor."])))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

