//
//  SpacialScannerViewControllerWrapper.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 15.06.2024.
//

import SwiftUI
import UIKit
import SpacialObjectsScanner

struct SpacialScannerViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = SpacialObjectDetectionViewController
    var viewModel: SpacialObjectScannerViewModel
    
    func makeUIViewController(context: Context) -> SpacialObjectDetectionViewController {
        SpacialObjectDetectionViewController(spacialObjectDetectionDelegate: viewModel)
    }

    func updateUIViewController(_ uiViewController: SpacialObjectDetectionViewController, context: Context) {
        // Update the view controller
    }
}
