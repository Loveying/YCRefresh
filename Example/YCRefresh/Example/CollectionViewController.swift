//
//  CollectionViewController.swift
//  YCRefreshExample
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    lazy var dataSource: [UIColor] = {
        var array: [UIColor] = []
        for _ in 0 ..< 10 {
            array.append(self.randomColor())
        }
        
        return array
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.backgroundColor = UIColor.white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.alwaysBounceVertical = true
        
        print("\(methodString)")
        
        let selector: Selector = NSSelectorFromString(methodString)
        if self.responds(to: selector) {
            self.perform(selector)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = dataSource[indexPath.item]
        return cell
    }
    
    deinit {
        print("Deinit")
    }
    
}

extension CollectionViewController {
    
    func randomColor() -> UIColor {
        let r = CGFloat.random(in: 0 ..< 255)
        let g = CGFloat.random(in: 0 ..< 255)
        let b = CGFloat.random(in: 0 ..< 255)
        
        let color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        
        return color
    }
    
}

extension CollectionViewController {
    
    @objc func example21() {
        collectionView!.yc.header = YCRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            /// 模拟处理数据
            var array: [UIColor] = []
            for _ in 0 ..< 5 {
                array.append(self.randomColor())
            }
            
            self.dataSource = array + self.dataSource
            
            /// 模拟延迟加载数据，1秒后完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView!.reloadData()
                
                self?.collectionView!.yc.header?.endRefreshing()
            }
        }
        
        collectionView!.yc.header?.beginRefreshing()
        
        collectionView!.yc.footer = YCRefreshBackNormalFooter { [weak self] in
            guard let self = self else { return }
            /// 模拟处理数据
            for _ in 0 ..< 5 {
                self.dataSource.append(self.randomColor())
            }
            
            /// 模拟延迟加载数据，1秒后完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView!.reloadData()
                
                self?.collectionView!.yc.footer?.endRefreshing()
            }
        }
        
        collectionView!.yc.footer?.automaticallyChangeAlpha = true
    }
    
}

