//
//  ARSceneViewControllerWrapper.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI
import UIKit

struct ARSceneViewControllerWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = ARSceneViewController
    var viewModel: ARSceneViewControllerViewModel

    func makeUIViewController(context: Context) -> ARSceneViewController {
        ARSceneViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: ARSceneViewController, context: Context) {
        // Update the view controller
    }
}
