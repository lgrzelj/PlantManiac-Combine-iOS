//
//  AboutApp.swift
//  PlantManiac
//
//  Created by ASELab on 10.08.2025..
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("LogoIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            Text("PlantManiac")
                .font(.custom("Georgia", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.accent)
            
            Text("about_app")
                .font(.custom("Georgia", size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)               .padding(.top, 20)
            
            Text("more_info")
                .font(.custom("Georgia", size: 15))
                .foregroundColor(.accent)
                .padding(.top, 20)

            Text("about_app_more")
                .font(.custom("Georgia", size: 15))
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
    }
}
