//
//  TableDataSource.swift
//  AICPeople-DEV
//
//  Created by Dat Tran on 4/10/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import UIKit

class CollectionDataSource<T, C: UICollectionViewCell>: NSObject,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data: [T]
    weak var mCollectionView: UICollectionView?
    
    var column: Int
    var sizeColumn: CGSize? = nil
    var height: CGFloat? = nil
    var ratioWidth: CGFloat? = nil
    var ratioHeight: CGFloat? = nil
    var marginBottom: CGFloat = 0
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var insets = UIEdgeInsets.zero
    
    var didSelectRowAt: ((_ data: T, _ row: Int) -> Void)?
    var bindingCell: ((_ cell: C, _ data: T, _ row: Int) -> Void)?

    var isPageScrolled = false
    var pageScrolled: ((_ position: Int) -> Void)?
    private var currentPage = 0 {
        didSet {
            if isPageScrolled {
                pageScrolled?(currentPage)
            }
        }
    }

    
    init(data: [T] = [], column: Int = 1) {
        self.data = data
        self.column = column
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mCollectionView = collectionView
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: C.self, for: indexPath)
        bindingCell?(cell, data[indexPath.row], indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _size = self.sizeColumn {
            return _size
        }
        var widthColumn: CGFloat = 0
        if let w = self.ratioWidth {
            widthColumn = w * collectionView.width
        } else {
            widthColumn = (collectionView.width - minimumLineSpacing * CGFloat(column - 1) - (insets.left + insets.right)) / CGFloat(column)
            widthColumn = widthColumn.rounded(.down)
        }
        let height: CGFloat
        if let h = ratioHeight {
            height = collectionView.height * h
        } else {
            height = self.height ?? widthColumn
        }
        let size = CGSize(width: widthColumn, height: height)
        self.sizeColumn = size
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectRowAt?(data[indexPath.row], indexPath.row)
    }
  
    func setupData(_ data:  [T]) {
        self.data = data
        mCollectionView?.reloadData()
    }

    func addItems(_ data:  T...) {
        self.data += data
        mCollectionView?.reloadData()
    }

    func addData(_ data:  [T]) {
        self.data += data
        mCollectionView?.reloadData()
    }

    var count: Int {
        return data.count
    }
    
    var isEmpty: Bool {
        return count == 0
    }

    func remove() {
        data.removeAll()
        mCollectionView?.reloadData()
    }
    
    func remove(at: Int) {
        data.remove(at: at)
        mCollectionView?.deleteItems(at: [IndexPath(row: at, section: 0)])
    }
    
    func removeCurrent() {
        if count == 0 { return }
        let index = currentPage
        if currentPage > 0 {
            currentPage -= 1
        }
        data.remove(at: index)
        mCollectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
    }

    subscript(_ index: Int) -> T {
        return data[index]
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard isPageScrolled,
            let size = sizeColumn else { return }
        let pageWidth = size.width + minimumLineSpacing
        
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.pointee.x

        var x: CGFloat = 0
        if velocity.x > 0 {
            x = ceil(currentOffset / pageWidth) * pageWidth
        } else if velocity.x < 0 {
            x = floor(currentOffset / pageWidth) * pageWidth
        } else {
            let d = targetOffset - pageWidth * CGFloat(currentPage)

            if abs(d) > pageWidth / 3 {
                if d > 0 {
                    x = CGFloat(currentPage + 1) * pageWidth
                } else {
                    x = CGFloat(currentPage - 1) * pageWidth
                }
            } else {
                x =  pageWidth * CGFloat(currentPage)
            }
        }
        if x < 0 {
            x = 0
        } else if x > scrollView.contentSize.width {
            x = scrollView.contentSize.width
        }
        targetContentOffset.pointee.x = currentOffset
        currentPage = Int(x / pageWidth)
        scrollView.setContentOffset(CGPoint(x: x, y: scrollView.contentOffset.y), animated: true)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
    
    func nextPage() -> Bool {
        guard isPageScrolled,
                  let size = sizeColumn, let view = mCollectionView else { return false }
        if currentPage + 1 >= data.count {
            return false
        }
        currentPage += 1
        let pageWidth = size.width + minimumLineSpacing
        view.setContentOffset(CGPoint(x: view.contentOffset.x + pageWidth, y: view.contentOffset.y), animated: true)
        return true
    }
    
    func prePage() -> Bool {
        guard isPageScrolled,
            let size = sizeColumn, let view = mCollectionView else { return false }
        if currentPage - 1 < 0 {
            return false
        }
        currentPage -= 1
        let pageWidth = size.width + minimumLineSpacing
        view.setContentOffset(CGPoint(x: view.contentOffset.x - pageWidth, y: view.contentOffset.y), animated: true)
        return true
    }
    
    func scrollToEnd() {
        currentPage = count - 1
        mCollectionView?.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .right, animated: true)
    }
    
    func scrollTo(_ index: Int) {
        guard isPageScrolled,
        let size = sizeColumn, let view = mCollectionView else { return }
        if index >= 0 && index < count {
            currentPage = index
            view.setContentOffset(CGPoint(x: (size.width + minimumLineSpacing) * CGFloat(currentPage), y: view.contentOffset.y), animated: true)
        }
    }
}
