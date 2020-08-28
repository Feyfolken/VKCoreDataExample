//
//  CollapseExpandViewDelegate.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 23.08.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import UIKit

/// Протокол, реализуемый классом, в котором делегатом UIScrollViewDelegate является CollapseExpandViewDelegate, когда есть необходимость переопределить реализацию методов UIScrollViewDelegate.
public protocol CollapseExpandViewDelegateListener: UIScrollViewDelegate {
     func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

extension CollapseExpandViewDelegateListener {
    func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {}
}

/// Класс-делегат, принимающий на входе "шапку" и view с контентом (например UICollectionView) и реализующий методы UIScrollViewDelegate таким образом, что обеспечивается работа механизма "collapse/expand view":  при скролле контента вверх шапка будет анимированно с изменением прозрачности скрываться под контентом, который меняет свое изначальное положение и перемещается вверх, при скролле вниз - возврат в исходное положение. При отмене перетаскивания, expandable view будет анимированно доводиться до конечного состояния, в зависимости от направления скролла.
public class CollapseExpandViewDelegate: NSObject {
    
    public weak var listener: CollapseExpandViewDelegateListener?

    private var expandableView: UIView!
    private var headerView: UIView!
    private var viewController: UIViewController!
    private var shouldSetupRoundCorners: Bool!
    
    private var previousListContentSize = CGSize.zero
    private var lastContentOffset: CGFloat = 0
    private let headerViewMinHeight: CGFloat = 0.0
    private var scrollUp = false
    private var isScrolling = false
    private var expandableViewVerticalSpacingToHeaderViewTop: CGFloat {
        get {
            expandableView.frame.origin.y - headerView.frame.origin.y
        }
    }
    private var headerViewMaxHeight: CGFloat {
        get {
            return headerView.frame.size.height
        }
    }
    
    private var animator: UIViewPropertyAnimator? = UIViewPropertyAnimator(duration: 0.5, timingParameters: UICubicTimingParameters(animationCurve: .easeOut))
    
    /// Метод инициализации
    /// - Parameters:
    ///   - expandableView: View с контентом, которая расположена под шапкой.
    ///   - headerView: View-шапка.
    ///   - viewController: Контроллер, на котором нужно реализовать логику collapse/expand.
    ///   - shouldSetupRoundCorners: Использовать / не использовать скругление углов.
    public init (with expandableView: UIView,
                 headerView: UIView,
                 viewController: UIViewController,
                 shouldSetupRoundCorners: Bool) {
        super.init()
        
        self.expandableView = expandableView
        self.headerView = headerView
        self.viewController = viewController
        self.shouldSetupRoundCorners = shouldSetupRoundCorners
        
        self.expandableView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [NSKeyValueObservingOptions.new], context: nil)

    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UICollectionView.contentSize) {
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize
            expandViewIfChangedContentSize(contentSize)
        }
        
        listener?.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    // MARK: Private methods
    private func expandViewIfChangedContentSize(_ contentSize: CGSize?) {
        guard let rawContentSize = contentSize else { return }
        
        if let scrollableView = expandableView as? UIScrollView {
            let expandedView = expandableViewVerticalSpacingToHeaderViewTop != 0
            if !previousListContentSize.equalTo(rawContentSize), expandedView {
                scrollableView.contentOffset = CGPoint.zero
                
                roundCollectionViewCorners()
            }
            
            previousListContentSize = rawContentSize
        }
    }

    private func roundCollectionViewCorners() {
        guard shouldSetupRoundCorners == true, let scrollableView = expandableView as? UIScrollView else { return }
        var customBounds = scrollableView.bounds
        customBounds.size.height = scrollableView.contentSize.height + scrollableView.frame.size.height
        let path = UIBezierPath(roundedRect: customBounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        expandableView.layer.mask = maskLayer
    }
    
    private func detectScrollDirection(_ currentOffsetY: CGFloat) {
        if lastContentOffset < currentOffsetY {
            scrollUp = true
            
        } else if lastContentOffset > currentOffsetY {
            scrollUp = false
        }
        
        lastContentOffset = currentOffsetY
    }
    
    private func correctCollapseViewSizeForScrolling(_ newHeaderViewHeight: CGFloat, _ scrollView: UIScrollView, _ minHeight: CGFloat) {
        if (newHeaderViewHeight < 0) {
            expandableView.frame.origin.y = headerView.frame.origin.y
            
        } else if expandableView.frame.origin.y != headerViewMinHeight {
            scrollView.contentOffset.y = 0
            expandableView.frame.origin.y = headerView.frame.origin.y + minHeight
        }
    }
    
    private func minScrollValue() -> CGFloat {
        var navigationBarPos: CGFloat = 0
        if let navigationBar = viewController.navigationController?.navigationBar {
            navigationBarPos = navigationBar.frame.origin.y + navigationBar.frame.size.height
        }
        
        let contentHeight = expandableViewContentHeight()
        let expandableViewPosition = navigationBarPos + headerViewMaxHeight + contentHeight
        let unvisibleHeight = expandableViewPosition - viewController.view.frame.size.height
        
        return unvisibleHeight < headerViewMaxHeight ?  headerViewMaxHeight - unvisibleHeight + 1 : headerViewMinHeight
    }
    
    private func expandableViewContentHeight() -> CGFloat {
        var contentHeight: CGFloat!
        if let contentView = expandableView as? UIScrollView {
            contentHeight = contentView.contentSize.height
            
        } else {
            contentHeight = expandableView.frame.height
        }
        
        return contentHeight
    }
    
    private func maxScrollValue() -> CGFloat {
        return headerViewMaxHeight
    }
    
    private func bringViewInDirectionOfScroll(_ scrollView: UIScrollView) {
        let maxHeight = maxScrollValue()
        let minHeight = minScrollValue()
        
        if scrollUp && (expandableViewVerticalSpacingToHeaderViewTop != minHeight) {
            changedHeight(forHeight: maxHeight)
            
        } else if !scrollUp && (expandableViewVerticalSpacingToHeaderViewTop != maxHeight) {
            expandableView.frame.size.height += expandableViewVerticalSpacingToHeaderViewTop
            changedHeight(forHeight: minHeight)
        }
        
        UIView.animate(withDuration: TimeInterval(scrollView.decelerationRate.rawValue)) {
            self.changeHeaderViewAlphaRelativeExpandableViewPosition(with: scrollView)
        }
    }
    
    private func changedHeight(forHeight value: CGFloat) {
        if (isScrolling) {
            return
        }
        
        self.animator?.addAnimations {
            self.expandableView.frame.origin.y = self.headerView.frame.origin.y +  value + 10
            self.viewController.view.layoutIfNeeded()
        }
        
        self.animator?.startAnimation()
    }
    
    private func changeHeaderViewAlphaRelativeExpandableViewPosition(with scrollView: UIScrollView) {
        let maxHeight = maxScrollValue()
        let minHeight = minScrollValue()
        let newHeaderViewHeight: CGFloat = expandableViewVerticalSpacingToHeaderViewTop - scrollView.contentOffset.y
        
        if newHeaderViewHeight > maxHeight {
            headerView.alpha = 1
            
        } else if newHeaderViewHeight < minHeight {
            headerView.alpha = 1
            
        } else {
            headerView.alpha = (newHeaderViewHeight * 1) / maxScrollValue()
        }
    }
    
    private func adjustExpandedViewFrameAccordingToNewHeaderViewHeight(_ newHeaderViewHeight: CGFloat, scrollView: UIScrollView) {
        let maxHeight = maxScrollValue()
        let minHeight = minScrollValue()
        
        if newHeaderViewHeight > maxHeight {
            expandableView.frame.origin.y = headerView.frame.origin.y + maxHeight
            
        } else if newHeaderViewHeight < minHeight {
            expandableView.frame.origin.y = headerView.frame.origin.y + minHeight
            
            correctCollapseViewSizeForScrolling(newHeaderViewHeight, scrollView, minHeight)
            
        } else if newHeaderViewHeight > 0 {
            expandableView.frame.origin.y = headerView.frame.origin.y + newHeaderViewHeight
            expandableView.frame.size.height = viewController.view.frame.height - expandableView.frame.origin.y + 150
            
            scrollView.contentOffset.y = 0
        }
    }
}

// MARK: UIScrollViewDelegate
extension CollapseExpandViewDelegate: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animator?.stopAnimation(true)
        
        listener?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        animator?.stopAnimation(true)
        
        listener?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrolling = true
        let currentOffsetY = scrollView.contentOffset.y
        detectScrollDirection(currentOffsetY)
        
        let newHeaderViewHeight: CGFloat = expandableViewVerticalSpacingToHeaderViewTop - currentOffsetY
        
        changeHeaderViewAlphaRelativeExpandableViewPosition(with: scrollView)
        adjustExpandedViewFrameAccordingToNewHeaderViewHeight(newHeaderViewHeight, scrollView: scrollView)
        
        listener?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
        
        if (!decelerate) {
            bringViewInDirectionOfScroll(scrollView)
        }
        
        listener?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        bringViewInDirectionOfScroll(scrollView)
        
        listener?.scrollViewDidEndDecelerating?(scrollView)
    }
}

extension CollapseExpandViewDelegate: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
