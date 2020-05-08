//
//  YCRefreshAutoStateFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshAutoStateFooter: YCRefreshAutoFooter {

    public var labelLeftInset: CGFloat = YCRefreshConst.labelLeftInset

    public lazy var stateLabel: UILabel = {
        let label = UILabel.standard()
        return label
    }()
    
    open var stateTitles: [YCRefresh.State: String] = [:]

    public func setTitle(_ text: String, for state: YCRefresh.State) {
        stateTitles[state] = text
        stateLabel.text = stateTitles[self.state]
    }
    
    public var refreshingTitleHidden: Bool = false
    
    @objc private func stateLabelClick() {
        if state == .idle {
            beginRefreshing()
        }
    }
    
    override open func prepare() {
        super.prepare()
        addSubview(stateLabel)
        
        setTitle(Bundle.localizedString(for: YCRefreshAutoFooterConst.idleText), for: .idle)
        setTitle(Bundle.localizedString(for: YCRefreshAutoFooterConst.refreshingText), for: .refreshing)
        setTitle(Bundle.localizedString(for: YCRefreshAutoFooterConst.noMoreDataText), for: .noMoreData)
        
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLabelClick)))
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.constraints.count == 0 {
            stateLabel.frame = bounds
        }
    }
    
    override open var state: YCRefresh.State {
        didSet {
            if refreshingTitleHidden, state == .refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = stateTitles[state]
            }
        }
    }

}
