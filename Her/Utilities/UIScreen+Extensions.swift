//
//  UIScreen+Extensions.swift
//  Res
//
//  Created by Steven Sarmiento on 4/2/24.
//

import UIKit

extension UIScreen {
    static var isLargeDevice: Bool {
        return UIScreen.main.bounds.width > 414 
    }
}
