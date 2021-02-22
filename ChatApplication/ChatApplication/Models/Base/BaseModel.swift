//
//  BaseModel.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/5/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel: NSObject {
    
    var id: Int = -1
    var name: String = ""
    var value: String = ""
    var isSelect = false
    var contentOther: String?
    
    func setupData(json: JSON) {
        
    }
    
    init(id: Int,name: String,value: String) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    init(id: Int,name: String) {
        self.id = id
        self.name = name
    }
  
    override required init() {
        
    }
    
    init(_ data: DescriptionBloodPressure) {
        self.name = data.name
        self.id = data.id
        self.isSelect = data.isSelect
        self.contentOther = data.contentOther
    }
}
