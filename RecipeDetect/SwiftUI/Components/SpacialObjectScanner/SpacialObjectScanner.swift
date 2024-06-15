//
//  SpacialObjectScanner.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 15.06.2024.
//

import Foundation
import SwiftUI
import ARKit
import SpacialObjectsScanner

class SpacialObjectScannerViewModel: ObservableObject, SpacialObjectDetectionDelegate {
    @Published private(set) var state: SpacialObjectDetectionState = .tapObject
    
    func previousState() {
        
    }
    
    func nextState() -> SpacialObjectDetectionState {
        switch(state) {
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
    
    private var arSceneViewModel: ARSceneViewControllerViewModel
    
    init(arSceneViewModel: ARSceneViewControllerViewModel) {
        self.arSceneViewModel = arSceneViewModel
    }
    
    var body: some View {
        ZStack {
            SpacialScannerViewControllerWrapper(viewModel: spacialObjectScannerviewModel)
            VStack(spacing: 0) {
                HStack {
                    Button(action: self.backAction) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Title")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Button(action: self.restartAction) {
                        Text("Restart")
                    }
                }
                
                Spacer()
                Button(action: self.nextAction) {
                    Text("Next")
                }
            }
        }
    }
    
    func backAction() {
        
    }
    
    func restartAction() {
        
    }
    
    func nextAction() {
        _ = spacialObjectScannerviewModel.nextState()
    }
    
//    var title: String {
//        
//    }
}
