//
//  YCRefreshStateHeader.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshStateHeader: YCRefreshHeader {

    public var lastUpdatedTimeText: ((_ lastUpdatedTime: Date?) -> String)?
    
    public lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel.standard()
        return label
    }()
    
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
    
    override public var lastUpdatedTimeKey: String {
        didSet {
            if lastUpdatedTimeLabel.isHidden {
                return
            }
            
            let lastUpdatedTime = UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
            if let lastUpdatedTimeText = lastUpdatedTimeText {
                lastUpdatedTimeLabel.text = lastUpdatedTimeText(lastUpdatedTime)
                return
            }
            
            if let lastUpdatedTime = lastUpdatedTime {
                let calendar = NSCalendar(calendarIdentifier: .gregorian)
                let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute]
                let components1 = calendar?.components(unitFlags, from: lastUpdatedTime)
                let components2 = calendar?.components(unitFlags, from: Date())

                let formatter = DateFormatter()
                var isToday = false
                if components1?.day == components2?.day {
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if components1?.year == components2?.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                
                let timeString = formatter.string(from: lastUpdatedTime)
                
                let string = "\(Bundle.localizedString(for: YCRefreshHeaderConst.lastTimeText))\(isToday ? Bundle.localizedString(for: YCRefreshHeaderConst.dateTodayText) : "")\(timeString)"
                lastUpdatedTimeLabel.text = string
            } else {
                let string = "\(Bundle.localizedString(for: YCRefreshHeaderConst.lastTimeText))\(Bundle.localizedString(for: YCRefreshHeaderConst.noneLastDateText))"
                lastUpdatedTimeLabel.text = string
            }
        }
    }
    
    override open func prepare() {
        super.prepare()
        addSubview(stateLabel)
        addSubview(lastUpdatedTimeLabel)
        
        setTitle(Bundle.localizedString(for: YCRefreshHeaderConst.idleText), for: .idle)
        setTitle(Bundle.localizedString(for: YCRefreshHeaderConst.pullingText), for: .pulling)
        setTitle(Bundle.localizedString(for: YCRefreshHeaderConst.refreshingText), for: .refreshing)
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.isHidden {
            return
        }
        
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0
        
        if lastUpdatedTimeLabel.isHidden {
            // 状态
            if noConstrainsOnStatusLabel {
                stateLabel.frame = bounds
            }
        } else {
            let stateLabelHeight = yc.height * 0.5
            
            if noConstrainsOnStatusLabel {
                stateLabel.frame = CGRect(x: 0, y: 0, width: yc.width, height: stateLabelHeight)
            }
            
            if lastUpdatedTimeLabel.constraints.count == 0 {
                lastUpdatedTimeLabel.frame = CGRect(x: 0, y: stateLabelHeight, width: yc.width, height: yc.height - lastUpdatedTimeLabel.yc.y)
            }
        }
    }
    
    override open var state: YCRefresh.State {
        didSet {
            self.stateLabel.text = stateTitles[state]
            self.lastUpdatedTimeKey = YCRefreshHeaderConst.lastUpdateTimeKey
        }
    }

}
