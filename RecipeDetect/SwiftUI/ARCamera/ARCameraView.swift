//
//  ARCameraView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI
//import SpacialObjectsScanner

struct ARCameraView: View {
    @StateObject private var viewModel = ARSceneViewControllerViewModel()
    
    @State private var state = "recipe"
    
    var body: some View {
        ZStack{
            if(state == "recipe"){
                RecipeListView(state: $state)
            }
            else if(state == "scanner"){
                SpacialObjectScanner()
            }
        }
        .onAppear{
            RecipeListView.newRequest = true
        }
        
    }

    private func screenCenter(_ size: CGSize) -> CGRect {
        let rectWidth = size.width - 8
        let rectHeight = size.height
        let x: CGFloat = 4
        let y = (rectHeight - rectWidth) / 2
        return CGRect(x: x, y: y, width: rectWidth, height: rectWidth)
    }
}

struct ARCameraView_Previews: PreviewProvider {
    static var previews: some View {
        ARCameraView()
    }
}
