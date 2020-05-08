//
//  UIScrollViewRefresh.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

private var headerKey: UInt8 = 0
private var footerKey: UInt8 = 0

public extension YC where Base: UIScrollView {
    
    var header: YCRefreshHeader? {
        set {
            if let newHeader = newValue {
                if header != newValue {
                    header?.removeFromSuperview()
                    base.insertSubview(newHeader, at: 0)
                    
                    objc_setAssociatedObject(base, &headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                header?.removeFromSuperview()
            }
        }
        get {
            return objc_getAssociatedObject(base, &headerKey) as? YCRefreshHeader
        }
    }
    
    var footer: YCRefreshFooter? {
        set {
            if let newFooter = newValue {
                if footer != newValue {
                    footer?.removeFromSuperview()
                    base.insertSubview(newFooter, at: 0)
                    
                    objc_setAssociatedObject(base, &footerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                footer?.removeFromSuperview()
            }
        }
        get {
            return objc_getAssociatedObject(base, &footerKey) as? YCRefreshFooter
        }
    }
}

