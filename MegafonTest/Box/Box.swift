//
//  Box.swift
//  MegafonTest
//
//  Created by Ботурбек Имомдодов on 27/01/25.
//

import Foundation

final class Box<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}
