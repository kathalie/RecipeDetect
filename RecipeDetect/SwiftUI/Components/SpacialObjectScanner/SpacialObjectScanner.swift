//
//  SpacialObjectScanner.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 15.06.2024.
//

import Foundation
import SwiftUI
import ARKit
import CGALWrapper
//import SpacialObjectsScanner

//class SpacialObjectScannerViewModel: ObservableObject, SpacialObjectDetectionDelegate
//{
//    @Published var arReferenceObject: ARReferenceObject?
//    @Published private(set) var state: SpacialObjectDetectionState = .startARSession
//    
//    func setState(newState: SpacialObjectDetectionState) {
//        state = newState
//    }
//    
//    func previousState() {
//        
//    }
//    
//    func nextState() -> SpacialObjectDetectionState {
//        switch(state) {
//        case .startARSession: state = .notReady
//        case .notReady: state = .detecting
//        case .detecting: state = .ready
//        case .ready: state = .defineBoundingBox
//        case .defineBoundingBox: state = .scan(progress: 0)
//        case .scan: state = .volume(arReferenceObject: nil)
//        case .volume: return state
//        }
//        
//        return state
//    }
//}

struct SpacialObjectScanner: View {
//    @StateObject var spacialObjectScannerViewModel: SpacialObjectScannerViewModel = SpacialObjectScannerViewModel()
    @StateObject var arSceneViewModel: ARSceneViewControllerViewModel = ARSceneViewControllerViewModel()
    @State private var coordinator: SpacialScannerViewControllerWrapper.Coordinator? = nil
//    @State private var productName: String?
    @Binding var state : String
    @Binding var product : Product?
    
    var body: some View {
        if arSceneViewModel.product == nil {
            VStack {
                SpacialScannerViewControllerWrapper(
    //                    viewModel: spacialObjectScannerViewModel,
                    arSceneViewModel: arSceneViewModel
                )
                .onAppear {
                    coordinator = SpacialScannerViewControllerWrapper(
    //                            viewModel: spacialObjectScannerViewModel,
                        arSceneViewModel: arSceneViewModel
                    ).makeCoordinator()
                }
            }
        }
        else {
            ZStack{
                Text("Redirecting to recipes...")
            }.onAppear{
                product = arSceneViewModel.product!
                state = "recipe"
            }
            //            Spacer()
//            if let product = arSceneViewModel.product {
//                Text("Product name: ") + Text(product.name)
//                HStack {
//                    Text("Volume: ")
//                    if let volume = product.volume {
//                        Text(String(volume))
//                    }
//                }
//            } else {
//                Text("Something went wrong")
//            }
//            Spacer()
        }
    }
    
//    var productMessage: String? {
//        switch(arSceneViewModel.state) {
//        case .initial: return nil
//        case .data where arSceneViewModel.classification!.confidence < 90, .error:
//            return "Failed to detect a product. Please, try again."
//        case .data:
//            return "This is \(arSceneViewModel.classification!.label).\nConfidence: \(arSceneViewModel.classification!.confidence)"
//        }
//    }
}
