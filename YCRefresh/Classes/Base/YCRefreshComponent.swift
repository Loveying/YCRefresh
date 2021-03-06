//
//  YCRefreshComponent.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshComponent: UIView {

    // MARK: - 刷新回调
    /// 正在刷新的回调
    var refreshingBlock: YCRefreshComponentAction?
    
    /// 回调对象
    private weak var refreshingTarget: NSObject?
    
    /// 回调方法
    private var refreshingAction: Selector?
    
    // MARK: - 刷新状态控制
    /// 进入刷新后的回调
    var beginRefreshingCompletionBlock: YCRefreshComponentAction?
    /// 带动画的结束刷新的回调
    var endRefreshingAnimationBeginAction: YCRefreshComponentAction?
    /// 结束刷新的回调
    var endRefreshingCompletionBlock: YCRefreshComponentAction?
    
    /// 是否正在刷新
    open var refreshing: Bool {
        return (self.state == .refreshing || self.state == .willRefresh)
    }
    
    /// 刷新状态
    open var state: YCRefresh.State = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    
    /// 拖拽百分比，根据拖拽进度设置透明度
    open var pullingPercent: CGFloat = 0 {
        didSet {
            if self.refreshing {
                return
            }
            if self.automaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    /// 根据拖拽比例自动切换透明度
    open var automaticallyChangeAlpha: Bool = false {
        didSet {
            if self.refreshing {
                return
            }
            if automaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    /// 父控件
    weak var scrollView: UIScrollView?
    /// Scroll View 初始 Inset
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// Scroll View 手势
    private var pan: UIPanGestureRecognizer?
    
    // MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        prepare()
    }
    
    /// 初始化
    open func prepare() {
        backgroundColor  = .clear
    }
    
    override public func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    
    /// 设置子控件 Frame
    open func placeSubviews() {}
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if state == .willRefresh {
            state = .refreshing
        }
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let newSuperview = newSuperview as? UIScrollView else {
            return
        }
        
        /// 移除监听
        removeObservers()
        
        self.scrollView = newSuperview
        
        /// 添加监听
        addObservers()
    }
    
    /// 添加监听
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: YCRefreshKeyPath.contentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: YCRefreshKeyPath.contentSize, options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: YCRefreshKeyPath.panState, options: options, context: nil)
    }
    
    /// 移除监听
    func removeObservers() {
        superview?.removeObserver(self, forKeyPath: YCRefreshKeyPath.contentOffset)
        superview?.removeObserver(self, forKeyPath: YCRefreshKeyPath.contentSize)
        pan?.removeObserver(self, forKeyPath: YCRefreshKeyPath.panState)
        pan = nil
    }
    
    /// 监听
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard isUserInteractionEnabled else {
            return
        }
        
        if keyPath == YCRefreshKeyPath.contentSize {
            scrollViewContentSizeDidChange(change)
        }
        
        guard !isHidden else {
            return
        }
        
        if keyPath == YCRefreshKeyPath.contentOffset {
            scrollViewContentOffsetDidChange(change)
        }
        else if keyPath == YCRefreshKeyPath.panState {
            scrollViewPanStateDidChange(change)
        }
    }
    
    /// 当 Scroll View 的 Content Size 发生改变的时候调用
    open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    /// 当 Scroll View 的 Content Offset 发生改变的时候调用
    open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    /// 当 Scroll View 的拖拽状态发生改变的时候调用
    open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    

    /// 开始刷新
    public func beginRefreshing(withCompletion block: (() -> Void)? = nil) {
        
        beginRefreshingCompletionBlock = block
        
        UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration) {
            self.alpha = 1.0
        }
        pullingPercent = 1.0
        
        if self.window != nil {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .willRefresh
                setNeedsDisplay()
            }
        }
    }
    
    /// 结束刷新
    public func endRefreshing(withCompletion block: (() -> Void)? = nil) {
        
        endRefreshingCompletionBlock = block
        
        DispatchQueue.main.async { [weak self] in
            self?.state = .idle
        }
    }
    
    /// 设置回调对象和回调方法
    func setRefreshing(target: NSObject?, action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }
    
    /// 触发回调，子类调用
    func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.refreshingBlock?()
            self.beginRefreshingCompletionBlock?()
            
            if let refreshingAction = self.refreshingAction,
                let refreshingTarget = self.refreshingTarget,
                refreshingTarget.responds(to: refreshingAction) {
                refreshingTarget.perform(refreshingAction)
            }
        }
    }

}
