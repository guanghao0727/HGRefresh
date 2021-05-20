//
//  UIScrollView+HGRefresh.swift
//  HGRefresh
//
//  Created by BaoGh on 2021/1/20.
//

import UIKit

extension UIScrollView {
    
    private struct AssociatedKey {
        static var refreshHeader: HGRefreshHeaderView!
        static var refreshFooter: HGRefreshFooterView!
    }
    
    var setRefreshHeader: HGRefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.refreshHeader) as? HGRefreshHeaderView ?? nil
        }
        set {
            if let lastHeader = objc_getAssociatedObject(self, &AssociatedKey.refreshHeader) as? HGRefreshHeaderView {
                lastHeader.removeFromSuperview()
            }
            if let header = newValue {
                addSubview(header)
            }
            objc_setAssociatedObject(self, &AssociatedKey.refreshHeader, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var refreshHeader: HGRefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.refreshHeader) as? HGRefreshHeaderView ?? nil
        }
    }
    
    var setRefreshFooter: HGRefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.refreshFooter) as? HGRefreshFooterView ?? nil
        }
        set {
            if let lastHeader = objc_getAssociatedObject(self, &AssociatedKey.refreshFooter) as? HGRefreshFooterView {
                lastHeader.removeFromSuperview()
            }
            if let header = newValue {
                addSubview(header)
            }
            objc_setAssociatedObject(self, &AssociatedKey.refreshFooter, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var refreshFooter: HGRefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.refreshFooter) as? HGRefreshFooterView ?? nil
        }
    }
    
}
