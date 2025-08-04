//
//  PlantFirestoreModel.swift
//  PlantManiac
//
//  Created by ASELab on 03.08.2025..
//

import Foundation

struct PlantFirestoreModel: Codable {
    var userID: String 
    var name: String
    var probability: Int
    var commonNames: [String]
    var description: String
    var summary: String
    var watering: String
    var sunlight: [String]
    var temperature: String
    var humidity: String
    var careLevel: Int
    var price: String
    var imageURL: String? 
}
