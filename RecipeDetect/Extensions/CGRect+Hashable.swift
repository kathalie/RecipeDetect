//
//  CGRect+Hashable.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}
