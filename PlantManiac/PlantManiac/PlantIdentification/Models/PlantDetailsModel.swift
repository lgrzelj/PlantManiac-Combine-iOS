//
//  Untitled.swift
//  PlantManiac
//
//  Created by ASELab on 01.08.2025..
//

import UIKit

struct PlantDetailsModel {
    var name: String
    var probability: Int
    var commonNames: [String]
    var description: String
    var summary: String
    var watering: String
    var sunlight: [String]
    var temperature: String
    var humidity: String
    var careLevel: Int  // 1 - 5 zvjezdica
    var price: String
    var plantImage: UIImage?
    
    init(name: String, probability: Int, commonNames: [String], description: String, summary: String, watering: String, sunlight: [String], temperature: String, humidity: String, careLevel: Int, price: String, plantImage: UIImage?) {
            self.name = name
            self.probability = probability
            self.commonNames = commonNames
            self.description = description
            self.summary = summary
            self.watering = watering
            self.sunlight = sunlight
            self.temperature = temperature
            self.humidity = humidity
            self.careLevel = careLevel
            self.price = price
            self.plantImage = plantImage
        }
}

