//
//  AboutViewController.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        self.webView.scrollView.yc.header = YCRefreshNormalHeader {
            self.webView.load(self.request)
        }
        
        self.webView.scrollView.yc.header?.beginRefreshing()
    }

}

extension AboutViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.yc.header?.endRefreshing()
    }
    
}
