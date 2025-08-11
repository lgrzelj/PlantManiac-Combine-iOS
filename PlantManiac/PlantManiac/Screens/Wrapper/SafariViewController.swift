//
//  SafariViewController.swift
//  PlantManiac
//
//  Created by ASELab on 05.08.2025..
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}
