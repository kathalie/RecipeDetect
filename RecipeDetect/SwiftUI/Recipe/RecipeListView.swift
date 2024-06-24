//
//  RecipeListView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct RecipeListView: View {
    //@State var queries: [(String, Int)]
    //@State private var recipes: [Recipe] = []
    @ObservedObject private var firebaseViewModel = FirebaseViewModel()
    static var newRequest : Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                if (firebaseViewModel.response.isEmpty){
                    ProgressView()
                } else {
                    List(firebaseViewModel.response, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                            RecipeListItemView(recipe: recipe)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ARCameraView()) {
                        Image(systemName: "camera")
                    }
                }
            }
            .navigationBarTitle("Recommendation list")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if(RecipeListView.newRequest){
                    print("fetch")
                    firebaseViewModel.getRecepies()
                    RecipeListView.newRequest = false
                }
            }
        }
    }
}

//struct RecipeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeListView(queries: [("orange", 300)])
//    }
//}
