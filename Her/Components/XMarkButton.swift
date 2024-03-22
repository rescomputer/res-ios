//
//  XmarkButton.swift
//  Her
//
//  Created by Steven Sarmiento on 3/21/24.
//

import SwiftUI

struct XMarkButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.black.opacity(0.2))
                .padding(10)
        }
        .background(Color.black.opacity(0.1))
        .clipShape(Circle())
        .pressAnimation()
    }
}
