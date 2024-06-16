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
    static var viewController : ViewController!
//    var viewModel: SpacialObjectScannerViewModel
    var arSceneViewModel: ARSceneViewControllerViewModel = ARSceneViewControllerViewModel()

    func makeUIViewController(context: Context) -> ViewController {
        SpacialScannerViewControllerWrapper.viewController = ViewController(
//            spacialObjectDetectionDelegate: viewModel,
            arSceneViewModel: arSceneViewModel
        )
        return SpacialScannerViewControllerWrapper.viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: SpacialScannerViewControllerWrapper
        

        init(_ parent: SpacialScannerViewControllerWrapper) {
            self.parent = parent
        }

        func capture() {
            print(SpacialScannerViewControllerWrapper.viewController ?? nil)
            viewController?.capture()
        }
    }
}
