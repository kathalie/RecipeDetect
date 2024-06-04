//
//  TimeText.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct TimeText: View {
    @State var time: String

    var body: some View {
        HStack {
            Image(systemName: "clock")
                .font(.system(size: 16))
            Text(time)
            Spacer()
        }
    }
}

struct TimeText_Previews: PreviewProvider {
    static var previews: some View {
        TimeText(time: "20 min")
    }
}
