//
//  UIApplication+.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/03.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
