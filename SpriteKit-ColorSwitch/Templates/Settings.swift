//
//  Settings.swift
//  ColorSwitch
//
//  Created by Erez Mizrahi on 14/10/2020.
//

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let ballCategorey: UInt32 = 0x1        // 01
    static let switchCategorey: UInt32 = 0x1 << 1 // 10
}


enum ZPositions {
    static let label: CGFloat = 0.0
    static let ball: CGFloat = 1.0
    static let colorCircle: CGFloat = 2.0
}
