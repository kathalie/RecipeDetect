//
//  FirestoreService.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation
import FirebaseDatabase
import CodableFirebase
import FirebaseVertexAI

final class FirebaseService {
    private let ref = Database.database().reference()
    
    func getRecipes(completion: @escaping ([Recipe]) -> Void) {
        ref
            .child("recipes")
            .observeSingleEvent(of: .value) { snapshot, _ in
            guard let value = snapshot.value else { return }
            do {
                let recipes = try FirebaseDecoder().decode([Recipe].self, from: value)
                completion(recipes)
            } catch {
                print(error)
            }
        }
    }
}
