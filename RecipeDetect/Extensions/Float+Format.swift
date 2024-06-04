//
//  Float+Format.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

extension Float {
    func formatted() -> String {
        String(describing: self).trimmingCharacters(in: .init(charactersIn: "0"))
    }
}
