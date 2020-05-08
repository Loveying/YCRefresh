//
//  YCRefreshBackStateFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshBackStateFooter: YCRefreshBackFooter {

    public var labelLeftInset: CGFloat = YCRefreshConst.labelLeftInset

    public lazy var stateLabel: UILabel = {
        let label = UILabel.standard()
        return label
    }()
    
    var stateTitles: [YCRefresh.State: String] = [:]

    public func setTitle(_ text: String, for state: YCRefresh.State) {
        stateTitles[state] = text
        stateLabel.text = stateTitles[self.state]
    }
    
    func title(for state: YCRefresh.State) -> String {
        return stateTitles[state] ?? ""
    }
    
    override open func prepare() {
        super.prepare()
        addSubview(stateLabel)
        
        setTitle(Bundle.localizedString(for: YCRefreshBackFooterConst.idleText), for: .idle)
        setTitle(Bundle.localizedString(for: YCRefreshBackFooterConst.pullingText), for: .pulling)
        setTitle(Bundle.localizedString(for: YCRefreshBackFooterConst.refreshingText), for: .refreshing)
        setTitle(Bundle.localizedString(for: YCRefreshBackFooterConst.noMoreDataText), for: .noMoreData)
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.constraints.count == 0 {
            stateLabel.frame = bounds
        }
    }
    
    override open var state: YCRefresh.State {
        didSet {
            stateLabel.text = stateTitles[state]
        }
    }

}
