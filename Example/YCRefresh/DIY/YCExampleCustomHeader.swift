//
//  YCExampleCustomHeader.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

class YCExampleCustomHeader: YCRefreshHeader {
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        var style = UIActivityIndicatorView.Style.gray
        if #available(iOS 13.0, *) {
            style = UIActivityIndicatorView.Style.medium
        }
        let view = UIActivityIndicatorView(activityIndicatorStyle: style)
        return view
    }()
    
    override func prepare() {
        super.prepare()
        addSubview(stateLabel)
        addSubview(loadingView)
        
        yc.height = 44
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        stateLabel.frame = bounds
        stateLabel.yc.y = 14
        stateLabel.yc.height = 30
        loadingView.frame = bounds
        loadingView.yc.y = 14
        loadingView.yc.height = 30
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)
    }
    
    override var state: YCRefresh.State {
        didSet {
            switch state {
            case .idle:
                loadingView.stopAnimating()
                stateLabel.text = "下拉刷新"
                stateLabel.isHidden = false
            case .pulling:
                loadingView.stopAnimating()
                stateLabel.text = "松开刷新"
                stateLabel.isHidden = false
            case .refreshing:
                loadingView.startAnimating()
                stateLabel.text = nil
                stateLabel.isHidden = true
            default:
                break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            stateLabel.alpha = pullingPercent * 2
        }
    }
}
