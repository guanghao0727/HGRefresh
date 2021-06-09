//
//  HGRefreshFooterView.swift
//  HGRefresh
//
//  Created by BaoGh on 2021/1/21.
//

import UIKit

class HGRefreshFooterView: HGRefreshBaseView {
    
    override var state: HGRefreshState {
        didSet {
            switch state {
            case .normal:
                stateLabel.text = "上拉加载更多"
            case .pulling:
                stateLabel.text = "松开立即加载"
            case .refreshing:
                stateLabel.text = "正在加载中..."
            case .NoMoreData:
                stateLabel.text = "没有更多数据"
            default:
                stateLabel.text = ""
            }
        }
    }
    private var isAutoRefreshing = false
    private var selfViewT: NSLayoutConstraint!
    
    class func refreshWithPullBlock(_ refreshBlock: @escaping RefreshViewBlock) -> HGRefreshFooterView {
        let footerView = HGRefreshFooterView()
        footerView.refreshBlock = refreshBlock
        footerView.isAutoRefreshing = false
        return footerView
    }
    
    class func refreshWithAutoBlock(_ refreshBlock: @escaping RefreshViewBlock) -> HGRefreshFooterView {
        let footerView = HGRefreshFooterView()
        footerView.refreshBlock = refreshBlock
        footerView.isAutoRefreshing = true
        return footerView
    }
    
    override func initView() {
        super.initView()
        
        state = .normal
    }
    
    override func didMoveToSuperview(_ newSuperview: UIScrollView) {
        super.didMoveToSuperview(newSuperview)
        
        newSuperview.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: newSuperview, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 44))
        newSuperview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: newSuperview, attribute: .centerX, multiplier: 1, constant: 0))
        selfViewT = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: newSuperview, attribute: .bottom, multiplier: 1, constant: newSuperview.contentSize.height)
        newSuperview.addConstraint(selfViewT)
    }
    
    override func scrollViewContentOffsetDidChange() {
        super.scrollViewContentOffsetDidChange()
        
        let insetT = scrollView.adjustedContentInset.top
        let insetB = scrollView.adjustedContentInset.bottom
        let progress = (scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height - insetT - insetB) / frame.height
        if !progress.isNaN {
            if progress >= 1 || state == .refreshing || state == .NoMoreData {
                alpha = 1
            } else if progress < 1, progress >= 0 {
                alpha = progress
            } else {
                alpha = 0
            }
            if scrollView.isDragging {
                if isAutoRefreshing {
                    if state == .normal, progress > 0 {
                        autoRefreshing()
                    }
                } else {
                    if state == .normal, progress >= 1 {
                        state = .pulling
                    } else if state == .pulling, progress < 1 {
                        state = .normal
                    }
                }
            } else if state == .pulling {
                beginRefreshing()
            }
        } else {
            alpha = 0
        }
    }
    
    override func scrollViewContentSizeDidChange() {
        super.scrollViewContentSizeDidChange()
        
        selfViewT.constant = scrollView.contentSize.height
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        state = .refreshing
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: self.lastContentInset.bottom + self.frame.height, right: self.scrollView.contentInset.right)
        } completion: { (finish) in
            self.refreshBlock?()
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        state = .finish
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) {
                self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: self.lastContentInset.bottom, right: self.scrollView.contentInset.right)
            } completion: { (finish) in
                if self.state != .NoMoreData {
                    self.state = .normal
                }
            }
        }
    }
    
    private func autoRefreshing() {
        state = .refreshing
        refreshBlock?()
    }
    
    // MARK: 设置没有更多加载
    
    func setNoMoreData() {
        state = .NoMoreData
        DispatchQueue.main.async {
            self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: self.lastContentInset.bottom + self.frame.height, right: self.scrollView.contentInset.right)
        }
    }
    
    // MARK: 重新设置更多加载
    
    func resetNoMoreData() {
        state = .normal
        DispatchQueue.main.async {
            self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: self.lastContentInset.bottom, right: self.scrollView.contentInset.right)
        }
    }

}
