//
//  YCExampleCustomBackFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

class YCExampleCustomBackFooter: YCRefreshBackFooter {
    
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
            
        stateLabel.text = "上拉查看更多内容😋"

        yc.height = 30
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        stateLabel.frame = bounds
        loadingView.frame = bounds
    }
    
    override var state: YCRefresh.State {
        didSet {
            switch state {
            case .idle:
                stateLabel.text = "上拉查看更多内容😋"
                stateLabel.isHidden = false
                loadingView.stopAnimating()
            case .pulling:
                stateLabel.text = "松开加载更多内容😋"
                stateLabel.isHidden = false
                loadingView.stopAnimating()
            case .refreshing:
                stateLabel.isHidden = true
                stateLabel.text = nil
                loadingView.startAnimating()
            case .noMoreData:
                stateLabel.text = "我已经被你看完了😱"
                stateLabel.isHidden = false
                loadingView.stopAnimating()
            default:
                break
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            loadingView.alpha = pullingPercent * 2
        }
    }
}
