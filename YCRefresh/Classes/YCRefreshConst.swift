//
//  YCRefreshConst.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

public struct YCRefreshConst {
    static let labelLeftInset : CGFloat = 25.0
    static let headerHeight   : CGFloat = 54.0
    static let footerHeight   : CGFloat = 44.0
    static let leaderWidth    : CGFloat = 44.0
    static let trailerWidth   : CGFloat = 44.0
    static let fastAnimationDuration    = 0.25
    static let slowAnimationDuration    = 0.4
}

struct YCRefreshKeyPath {
    static let contentOffset     = "contentOffset"
    static let contentInset      = "contentInset"
    static let contentSize       = "contentSize"
    static let panState          = "state"
}

public struct YCRefreshHeaderConst {
    static let lastUpdateTimeKey = "YCRefreshHeaderLastUpdateTimeKey"
    
    static let idleText          = "YCRefreshHeaderIdleText"
    static let pullingText       = "YCRefreshHeaderPullingText"
    static let refreshingText    = "YCRefreshHeaderRefreshingText"

    static let lastTimeText      = "YCRefreshHeaderLastTimeText"
    static let dateTodayText     = "YCRefreshHeaderDateTodayText"
    static let noneLastDateText  = "YCRefreshHeaderNoneLastDateText"
}

public struct YCRefreshAutoFooterConst {
    static let idleText          = "YCRefreshAutoFooterIdleText"
    static let refreshingText    = "YCRefreshAutoFooterRefreshingText"
    static let noMoreDataText    = "YCRefreshAutoFooterNoMoreDataText"
}

public struct YCRefreshBackFooterConst {
    static let idleText          = "YCRefreshBackFooterIdleText"
    static let pullingText       = "YCRefreshBackFooterPullingText"
    static let refreshingText    = "YCRefreshBackFooterRefreshingText"
    static let noMoreDataText    = "YCRefreshBackFooterNoMoreDataText"
}


public let YCRefreshLabelFont      = UIFont.boldSystemFont(ofSize: 14)
public let YCRefreshLabelTextColor = UIColor.lightGray
