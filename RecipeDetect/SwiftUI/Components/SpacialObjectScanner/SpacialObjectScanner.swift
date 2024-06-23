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

class SpacialObjectScannerViewModel: ObservableObject, SpacialObjectDetectionDelegate
{
    func setState(newState: SpacialObjectDetectionState) {
        state = newState
    }
    
    @Published private(set) var state: SpacialObjectDetectionState = .tapObject
    
    func previousState() {
        
    }
    
    func nextState() -> SpacialObjectDetectionState {
        switch(state) {
        case .startARSession: state = .tapObject
        case .tapObject: state = .boundObject
        case .boundObject: state = .scan(progress: 0)
        case .scan: state = .info(arReferenceObject: nil)
        case .info: return state
        }
        return state
    }
}

struct SpacialObjectScanner: View {

    @StateObject var spacialObjectScannerviewModel: SpacialObjectScannerViewModel = SpacialObjectScannerViewModel()
    @StateObject var arSceneViewModel: ARSceneViewControllerViewModel = ARSceneViewControllerViewModel()
    @State private var coordinator: SpacialScannerViewControllerWrapper.Coordinator? = nil
    @State private var productName : String = ""
    
    
    
    var body: some View {
        VStack {
            ZStack {
                SpacialScannerViewControllerWrapper(
                    viewModel: spacialObjectScannerviewModel, arSceneViewModel: arSceneViewModel)
                    .onAppear {
                        coordinator = SpacialScannerViewControllerWrapper(
                            viewModel: spacialObjectScannerviewModel, arSceneViewModel: arSceneViewModel
                        ).makeCoordinator()

                    }
                VStack(spacing: 0) {
    //                HStack {
    //                    Button(action: self.backAction) {
    //                        Image(systemName: "arrow.left")
    //                            .foregroundColor(.white)
    //                    }
    //                    Spacer()
    //                    Text(title)
    //                        .foregroundColor(.white)
    //                        .font(.headline)
    //                    Spacer()
    //                    Button(action: self.restartAction) {
    //                        Text("Restart")
    //                    }
    //                }
                    Spacer()
                    Text(CGALWrapper.testStr())
                    Text(productName)
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(Color.black)
                    Text(productMessage)
                        .background(Color.black)
                    Spacer()
    //                Text("Session info")
    //                Text(productMessage)
    //                Spacer()
    //                Text(hint)
    //                Spacer()
    //                if hasNextButton {
    //                    Button(action: self.nextAction) {
    //                        Text("Next")
    //                    }
    //                }
                }
            }
            Button(action: {
                coordinator?.capture()
            }){
                Text("Define object")
            }
        }
    }
    
//    func backAction() {
//        
//    }
//    
//    func restartAction() {
//        
//    }
//    
//    func nextAction() {
//        _ = spacialObjectScannerviewModel.nextState()
//    }
    var productMessage: String {
        switch(arSceneViewModel.state) {
        case .initial: return "Init"
        case .data: return "Detected: \(arSceneViewModel.classification!.label) with confidence: \(arSceneViewModel.classification!.confidence)"
        case .error: return "Error"
        }
    }
//    
//    var title: String {
//        switch(spacialObjectScannerviewModel.state) {
//        case .startARSession: return "Initialiying session..."
//        case .tapObject: return "Defining product"
//        case .boundObject: return "Bounding object"
//        case .scan(let progress): return "Scanning \(progress)%"
//        case .info: return "Estimated"
//        }
//    }
//    
//    var hint: String {
//        switch(spacialObjectScannerviewModel.state) {
//        case .startARSession: return "Wait a while..."
//        case .tapObject: return "Point your camera and tap on the product you wish to use for cooking"
//        case .boundObject: return "Adjust the bounding box"
//        case .scan: return "Move your camera around the product to scan it. Do not move the product!"
//        case .info(let referenceObject): return "\(referenceObject?.description)"
//        }
//    }
//    
//    var hasNextButton: Bool {
//        switch(spacialObjectScannerviewModel.state) {
//        case .info: return false
//        default: return true
//        }
//    }
}
