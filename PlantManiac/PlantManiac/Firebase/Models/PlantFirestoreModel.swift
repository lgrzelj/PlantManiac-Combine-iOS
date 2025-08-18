//
//  PlantFirestoreModel.swift
//  PlantManiac
//
//  Created by ASELab on 03.08.2025..
//

import Foundation
import FirebaseFirestore

struct PlantFirestoreModel: Identifiable,Codable {
    @DocumentID var id: String?
    var userID: String
    var name: String
    var probability: Int?
    var description: String
    var summary: String
    var watering: String
    var sunlight: [String]
    var temperature: String
    var humidity: String
    var careLevel: Int
    var price: String
    var imageURL: String?
    var createdAt: Date?
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
          case id
          case userID = "userId"
          case name
          case probability
          case description
          case summary
          case watering
          case sunlight
          case temperature
          case humidity
          case careLevel
          case price
          case imageURL = "imageUrl"
          case createdAt
          case isLiked
      }
}


