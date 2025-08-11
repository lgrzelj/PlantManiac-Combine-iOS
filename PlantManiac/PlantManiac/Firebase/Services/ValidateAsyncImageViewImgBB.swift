//
//  ValidateAsyncImageViewImgBB.swift
//  PlantManiac
//
//  Created by ASELab on 04.08.2025..
//

import Foundation

import SwiftUI

struct ValidatedAsyncImageView: View {
    let urlString: String?
    @State private var isValidURL: Bool? = nil
    
    var body: some View {
        Group {
            if isValidURL == true {
                AsyncImage(url: URL(string: urlString ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else if isValidURL == false {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            validateImageURL()
        }
    }
    
    private func validateImageURL() {
        guard let url = URL(string: urlString ?? "") else {
            self.isValidURL = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // Brži nego GET
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    self.isValidURL = true
                } else {
                    self.isValidURL = false
                }
            }
        }.resume()
    }
}
