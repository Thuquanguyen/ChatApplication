//
//  ESOptionSelectPresenter.swift
//  E-Office
//
//  Created by VietHD-D3 on 4/8/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

class ESOptionSelectPresenter {
    
    weak var delegate: ESOptionSelectDelegate?
    
    private var items: [OptionItem] = []
    
    var filterdItems: [OptionItem] = []
    
    var selectedItemIdList: [Int] = []
    
    var limitSelectAmount: Int = 0
    
    
    /// set data for option select view
    ///
    /// - Parameters:
    ///   - options: array of OptionItem
    ///   - selectedIds: array of selected id
    ///   - limitSelectAmount: select limitation ( default 0: unlimit)
    func setOptionSelectData(options: [OptionItem], selectedIds: [Int], limitSelectAmount: Int = 0) {
        self.items = options
        self.filterdItems = items
        self.selectedItemIdList = selectedIds
        self.limitSelectAmount = limitSelectAmount
        
//        self.delegate?.refreshOptionTableView(updateTableHeigh: true)
    }
    
    func dataForCellAt(indexPath: IndexPath) -> (title: String, isSelected: Bool) {
       let itemData = filterdItems[indexPath.row]
       return (itemData.title, selectedItemIdList.contains(itemData.id))
    }
    
    func toggleSelectionForItemAt(indexPath: IndexPath) -> (title: String, isSelected: Bool) {
        let itemData = filterdItems[indexPath.row]
        if (selectedItemIdList.contains(itemData.id)) {
            selectedItemIdList = selectedItemIdList.filter{ $0 != itemData.id}
        } else {
            selectedItemIdList.append(itemData.id)
            if (limitSelectAmount > 0 && selectedItemIdList.count > limitSelectAmount) {
                selectedItemIdList.removeFirst()
                self.delegate?.refreshOptionTableView(updateTableHeigh: false)
            }
        }
        return (itemData.title, selectedItemIdList.contains(itemData.id))
    }
    
    func filterOption(condition: String) {
        if(condition.isEmpty) {
            filterdItems = items
        } else {
            filterdItems = items.filter{
                $0.title.lowercased().contains(condition.lowercased())
            }
        }
        self.delegate?.refreshOptionTableView(updateTableHeigh: false)
    }
    
    struct OptionItem {
        var id: Int
        var title: String
    }
}
