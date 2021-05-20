//
//  HGRefreshView.swift
//  HGRefresh
//
//  Created by BaoGh on 2021/1/20.
//

import UIKit

enum RefreshState {
    case normal
    case pulling
    case refreshing
    case finish
    case NoMoreData
}

typealias RefreshViewBlock = () -> ()

class HGRefreshBaseView: UIView {
    
    var refreshBlock: RefreshViewBlock?
    var state: RefreshState = .normal
    private(set) var lastContentInset: UIEdgeInsets!
    private var contentOffsetObserve: NSKeyValueObservation?
    private var contentSizeObserve: NSKeyValueObservation?
    
    let stateLabel = UILabel()
    var scrollView: UIScrollView!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        stateLabel.textColor = .black
        stateLabel.textAlignment = .center
        stateLabel.font = .boldSystemFont(ofSize: 14)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateLabel)
        
        addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let newSuperview = superview, newSuperview.isKind(of: UIScrollView.self) {
            scrollView = newSuperview as? UIScrollView
            didMoveToSuperview(scrollView)
            
            lastContentInset = scrollView.contentInset
            contentOffsetObserve = scrollView.observe(\.contentOffset, options: .new, changeHandler: { (scrollView, _) in
                self.scrollViewContentOffsetDidChange()
            })
            contentSizeObserve = scrollView.observe(\.contentSize, options: .new, changeHandler: { (scrollView, _) in
                self.scrollViewContentSizeDidChange()
            })
        } else {
            contentOffsetObserve = nil
            contentSizeObserve = nil
            DispatchQueue.main.async {
                if self.isKind(of: HGRefreshHeaderView.self) {
                    self.scrollView.contentInset = UIEdgeInsets(top: self.lastContentInset.top, left: self.scrollView.contentInset.left, bottom: self.scrollView.contentInset.bottom, right: self.scrollView.contentInset.right)
                } else if self.isKind(of: HGRefreshFooterView.self) {
                    self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: self.lastContentInset.bottom, right: self.scrollView.contentInset.right)
                }
            }
        }
    }
    
    func didMoveToSuperview(_ newSuperview: UIScrollView) {
        
    }
    
    // MARK: 监听
    
    func scrollViewContentOffsetDidChange() {
        
    }
    
    func scrollViewContentSizeDidChange() {
        
    }
    
    // MARK: 开始刷新
    
    func beginRefreshing() {
        
    }
    
    // MARK: 结束刷新
    
    func endRefreshing() {
        
    }
    
}
