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
//    typealias UIViewControllerType = SpacialObjectDetectionViewController
//    static var viewController : SpacialObjectDetectionViewController!
//    var viewModel: SpacialObjectScannerViewModel
//    var arSceneViewModel: ARSceneViewControllerViewModel = ARSceneViewControllerViewModel()
//
//    func makeUIViewController(context: Context) -> SpacialObjectDetectionViewController {
//        SpacialScannerViewControllerWrapper.viewController = SpacialObjectDetectionViewController(spacialObjectDetectionDelegate: viewModel, arSceneViewModel: arSceneViewModel)
//        return SpacialScannerViewControllerWrapper.viewController
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

//        func capture() {
//            print(SpacialScannerViewControllerWrapper.viewController ?? nil)
//            viewController?.capture()
//        }
    }
}
