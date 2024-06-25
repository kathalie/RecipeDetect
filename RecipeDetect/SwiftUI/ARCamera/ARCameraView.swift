//
//  ARCameraView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct ARCameraView: View {
//    @StateObject private var viewModel = ARSceneViewControllerViewModel()
    
    @State private var state = "scanner"
    @State private var product : Product? = nil
    
    var body: some View {
        ZStack{
            if(state == "recipe"){
                if let product {
                    RecipeListView(state: $state, product: product)
                        .onAppear{
                            RecipeListView.newRequest = true
                        }
                }
            }
            else if(state == "scanner"){
                SpacialObjectScanner(state: $state, product: $product)
            }
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
