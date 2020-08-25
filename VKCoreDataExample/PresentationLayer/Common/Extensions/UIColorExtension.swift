//
//  UIColorExtension.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 23.08.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import UIKit

public extension UIColor {
    
    //MARK: Design colors
    static var dc_AsphaltGray: UIColor {return UIColor(red: 40, green: 39, blue: 39, alpha: 1.0)}
    static var dc_BrightYellow: UIColor {return UIColor(red: 255, green: 243, blue: 50, alpha: 1.0)}


    //MARK: Simple UIColor initializer from RGB
    convenience init(red: Int, green: Int, blue: Int, alpha: Float) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(alpha))
    }
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

