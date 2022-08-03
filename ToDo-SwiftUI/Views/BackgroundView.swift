//
//  BackgroundView.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/03.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}
