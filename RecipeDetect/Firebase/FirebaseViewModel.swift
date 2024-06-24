//
//  FirebaseViewModel.swift
//  RecipeDetect
//
//  Created by Olesia Petrova on 24.06.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class FirebaseViewModel : ObservableObject{
    private let db = Firestore.firestore()
    @Published var state: String = ""
    @Published var response : [Recipe] = []
    private var isError: Bool = false
    
    func getRecepies(){
        var ref: DocumentReference? = nil

        ref = db.collection("generate").addDocument(data: [
            "products": "potatoes 1 kg apple 400 g",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.state = "Error adding document: \(err.localizedDescription)"
                self.isError = true
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.listenToDocumentChanges(docRef: ref!)
            }
        }
    }
    
    private func listenToDocumentChanges(docRef: DocumentReference) {
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                self.state = "Error fetching document: \(error!.localizedDescription)"
                self.isError = true
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                self.state = "Document data was empty."
                self.isError = true
                return
            }
            
            print("Current data: \(data)")
            if let status = data["status"] as? [String: Any], let stateValue = status["state"] as? String {
                if stateValue == "ERRORED" {
                    self.state = status["error"] as? String ?? "Unknown error"
                    self.isError = true
                    return
                }
                if stateValue != "COMPLETED" {
                    self.state = stateValue
                    self.isError = false
                } else {
                    if let responseOutput = data["output"] as? String {
                        //print(responseOutput)
                        self.response = self.parseResponse(response: responseOutput)
//                        let markdownParser = MarkdownParser()
//                        output = markdownParser.parse(responseOutput)
                        self.state = "COMPLETED"
                        self.isError = false
                    }
                }
            }
        }
    }
    
    private func parseResponse(response : String) -> [Recipe] {
        let jsonString = response.replacingOccurrences(of: "`", with: "").replacingOccurrences(of: "json", with: "")
        print(jsonString)
        var recipes : [Recipe] = []
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                recipes = try decoder.decode([Recipe].self, from: jsonData)
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        return recipes
    }
    
}
