//
//  ARViewControllerWrapper.swift
//  SpacialObjectsScanner
//
//  Created by Kathryn Verkhogliad on 09.06.2024.
//

import SwiftUI
import UIKit

public struct SpacialScannerViewControllerWrapper: UIViewControllerRepresentable {
    public init() {
        
    }
    
    public typealias UIViewControllerType = ViewController

    public func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }

    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller
    }
}
