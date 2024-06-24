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
    @State private var productName : String = ""
    
    var body: some View {
        VStack {
            ZStack {
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
                VStack(spacing: 0) {
                    Spacer()
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(Color.black)
                    Text(productMessage)
                        .background(Color.black)
                    Spacer()
                }
            }
//            Button(action: {
//                coordinator?.capture()
//            }){
//                Text("Define object")
//            }
        }
    }
    
    var productMessage: String {
        switch(arSceneViewModel.state) {
        case .initial: return "Init"
        case .data: return "Detected: \(arSceneViewModel.classification!.label) with confidence: \(arSceneViewModel.classification!.confidence)"
        case .error: return "Error"
        }
    }
}
