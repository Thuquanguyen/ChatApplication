//
//  BaseDataSource.swift
//  CTT_BN
//
//  Created by IchNV-D1 on 4/23/19.
//  Copyright © 2019 VietHD-D3. All rights reserved.
//

import UIKit

// MARK: - BaseDataSourceProtocol
protocol BaseDataSourceProtocol: class {
    associatedtype Element
    var element: Element { get set }
}

// MARK: - Base DataSource
class BaseDataSource<T>: NSObject, BaseDataSourceProtocol {
    typealias Element = T
    
    // MARK: Variables
    var element: Element
    
    init(element: Element) {
        self.element = element
    }
    
}
