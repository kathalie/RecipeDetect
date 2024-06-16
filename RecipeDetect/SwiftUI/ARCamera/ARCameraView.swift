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

    var body: some View {
        NavigationView {
            ZStack {
//                GeometryReader { geometry in
//                    ARSceneViewControllerWrapper(viewModel: viewModel)
//                        .drawCaptureBox(screenCenter(geometry.size))
//                }
                SpacialObjectScanner(arSceneViewModel: viewModel)
                
                
                switch viewModel.state {
                    case .initial:
                        EmptyView()
                    case let .data(detections, image, size):
                        NextButton(destination: ImageCaptureView(detections: detections, image: image, size: size))
                    case let .error(error):
                        VStack {
                            HStack {
                                Image("error")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text(error.description)
                            }
                            .padding(.horizontal)
                            .background { Color.white.opacity(0.5) }
                            Spacer()
                        }
                    }
                }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.resetState()
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
