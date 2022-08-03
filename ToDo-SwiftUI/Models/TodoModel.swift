//
//  TodoModel.swift
//  ToDo-SwiftUI
//
//  Created by Kim Insub on 2022/08/02.
//

import Foundation

struct TodoModel: Hashable {
    var task: String
    var isDone: Bool
    var uuid: UUID
}
