//
//  Extension.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

private var MethodKey: UInt8 = 0
public extension UIViewController {
    
    var methodString: String {
        set {
            objc_setAssociatedObject(self, &MethodKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &MethodKey) as? String ?? ""
        }
    }
}
