//
//  UIWindowExtension.swift
//  Join Us
//
//  Created by Alex Tam on 3/9/2023.
//

import Foundation
import UIKit

extension UIWindow {
    static var keySafeAreaTop: CGFloat {
        let top = keySafeAreaInsets.top
        return top == 0 ? 20 : top
    }
    
    static var keySafeAreaBottom: CGFloat {
        return keySafeAreaInsets.bottom
    }
    
    static var keySafeAreaInsets: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return UIEdgeInsets.zero
            }
            
            let safeAreaInsets = windowScene.windows.first?.safeAreaInsets
            return safeAreaInsets ?? UIEdgeInsets.zero
        } else {
            let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets
            return safeAreaInsets ?? UIEdgeInsets.zero
        }
    }
}
