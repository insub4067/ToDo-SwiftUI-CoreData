//
//  View+.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/04.
//

import Foundation
import SwiftUI

extension View {
    func customAlert(primaryAction: @escaping (String) -> Void, secondaryAction: @escaping () -> Void) -> () {

        let alert = UIAlertController(title: "이름 변경", message: "새로운 이름을 입력하세요.", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "입력"
        }

        alert.addAction(.init(title: "취소", style: .cancel, handler: { _ in
            secondaryAction()
        }))

        alert.addAction(.init(title: "적용", style: .destructive, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))

        rootController().present(alert, animated: true, completion: nil)
    }

    private func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
