//
//  HGRefreshHeaderView.swift
//  HGRefresh
//
//  Created by BaoGh on 2021/1/21.
//

import UIKit

class HGRefreshHeaderView: HGRefreshBaseView {
    
    override var state: HGRefreshState {
        didSet {
            switch state {
            case .normal:
                stateLabel.text = "下拉可以刷新"
            case .pulling:
                stateLabel.text = "松开立即刷新"
            case .refreshing:
                stateLabel.text = "正在加载中..."
            case .finish:
                stateLabel.text = "加载完成"
            default:
                stateLabel.text = ""
            }
        }
    }
    
    class func refreshBlock(_ refreshBlock: @escaping RefreshViewBlock) -> HGRefreshHeaderView {
        let headerView = HGRefreshHeaderView()
        headerView.refreshBlock = refreshBlock
        return headerView
    }
    
    override func initView() {
        super.initView()
        
        state = .normal
    }
    
    override func didMoveToSuperview(_ newSuperview: UIScrollView) {
        super.didMoveToSuperview(newSuperview)
        
        newSuperview.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: newSuperview, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 54))
        newSuperview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: newSuperview, attribute: .centerX, multiplier: 1, constant: 0))
        newSuperview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: newSuperview, attribute: .top, multiplier: 1, constant: 0))
    }
    
    override func scrollViewContentOffsetDidChange() {
        super.scrollViewContentOffsetDidChange()
        
        let progress = -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top - scrollView.contentInset.top) / frame.height
        if !progress.isNaN {
            if progress >= 1 || state == .refreshing {
                alpha = 1
            } else if progress < 1, progress >= 0 {
                alpha = progress
            } else {
                alpha = 0
            }
            if state == .refreshing {
                DispatchQueue.main.async {
                    if progress < 0 {
                        self.scrollView.contentInset = UIEdgeInsets(top: self.lastContentInset.top, left: self.scrollView.contentInset.left, bottom: self.scrollView.contentInset.bottom, right: self.scrollView.contentInset.right)
                    } else {
                        self.scrollView.contentInset = UIEdgeInsets(top: self.lastContentInset.top + self.frame.height, left: self.scrollView.contentInset.left, bottom: self.scrollView.contentInset.bottom, right: self.scrollView.contentInset.right)
                    }
                }
            } else if scrollView.isDragging {
                if state == .normal, progress >= 1 {
                    state = .pulling
                } else if state == .pulling, progress < 1 {
                    state = .normal
                }
            } else if state == .pulling {
                beginRefreshing()
            }
        } else {
            alpha = 0
        }
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        state = .refreshing
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = UIEdgeInsets(top: self.lastContentInset.top + self.frame.height, left: self.scrollView.contentInset.left, bottom: self.scrollView.contentInset.bottom, right: self.scrollView.contentInset.right)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: -(self.frame.height + self.scrollView.adjustedContentInset.top - self.scrollView.contentInset.top)), animated: false)
        } completion: { (finish) in
            self.refreshBlock?()
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        state = .finish
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut) {
                self.scrollView.contentInset = UIEdgeInsets(top: self.lastContentInset.top, left: self.scrollView.contentInset.left, bottom: self.scrollView.contentInset.bottom, right: self.scrollView.contentInset.right)
            } completion: { (finish) in
                self.state = .normal
            }
        }
    }
    
}
