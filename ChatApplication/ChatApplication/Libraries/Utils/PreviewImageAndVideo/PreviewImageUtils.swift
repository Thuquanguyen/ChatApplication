//
//  PreviewImageUtils.swift
//  YTeThongMinh
//
//  Created by ThanhND on 7/22/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation

struct DataItem {
    let galleryItem: GalleryItem
}

@objc protocol PreviewImageDelete: class {
    @objc optional func launchedCompletion()
    @objc optional func closedCompletion()
    @objc optional func swipedToDismissCompletion()
    @objc optional func landedPageAtIndexCompletion(index: Int)
}

class PreviewImageUtils {

}

class GalleryItemsDataSourceDeletgate: NSObject, GalleryItemsDataSource, GalleryItemsDelegate, GalleryDisplacedViewsDataSource {
    
    var datas: [DataItem] = []
    var didTapDeleteBtn: ((Int, DataItem)->())?
    var provideDisplacementItem: ((Int) -> (DisplaceableView?))?
    
    init(datas: [DataItem],
                  didTapDeleteBtn: ((Int, DataItem)->())? = nil,
                  provideDisplacementItem: ((Int) -> (DisplaceableView?))? = nil) {
        self.datas = datas
        self.didTapDeleteBtn = didTapDeleteBtn
        self.provideDisplacementItem = provideDisplacementItem
    }
    
    func itemCount() -> Int {
        datas.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return datas[index].galleryItem
    }
    
    func removeGalleryItem(at index: Int) {
        print("remove at index")
        didTapDeleteBtn?(index, datas[index])
    }
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return provideDisplacementItem?(index)
    }
}

