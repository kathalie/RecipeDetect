//
//  SpacialScannerViewControllerWrapper.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 15.06.2024.
//

import SwiftUI
import UIKit
//import SpacialObjectsScanner

struct SpacialScannerViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
//    var viewModel: SpacialObjectScannerViewModel
    
    func makeUIViewController(context: Context) -> ViewController {
//        SpacialObjectScanner(spacialObjectDetectionDelegate: viewModel)
//        ViewController()
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle.main
        )
        let vc = storyboard.instantiateViewController(identifier: "ViewController") as! ViewController
        
        return vc
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller
    }
}
