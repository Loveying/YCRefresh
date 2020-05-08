//
//  YCRefresh.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

public class YCRefresh {
    /// 刷新控件的状态
    public enum State: Int {
        /// 闲置
        case idle = 1
        /// 松开就可以进行刷新
        case pulling
        /// 正在刷新中
        case refreshing
        /// 即将刷新
        case willRefresh
        /// 没有更多的数据
        case noMoreData
    }
}
public typealias YCRefreshComponentAction = () -> Void

public final class YC<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol YCCompatible { }

public extension YCCompatible {
    
    var yc: YC<Self> {
        return YC(self)
    }
    
    static var yc: YC<Self>.Type {
        return YC<Self>.self
    }
    
}

extension UIView: YCCompatible {}
