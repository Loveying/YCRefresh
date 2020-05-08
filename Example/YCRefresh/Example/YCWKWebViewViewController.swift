//
//  YCWKWebViewViewController.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit
import WebKit

class YCWKWebViewViewController: UIViewController {

    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        let header = YCRefreshNormalHeader {
            self.webView.load(self.request)
        }
        header.stateLabel.isHidden = true
        header.lastUpdatedTimeLabel.isHidden = true
        
        self.webView.scrollView.yc.header = header
        
        header.beginRefreshing()
    }

    deinit {
        print("Deinit")
    }
    
}

extension YCWKWebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.yc.header?.endRefreshing()
    }
    
}
