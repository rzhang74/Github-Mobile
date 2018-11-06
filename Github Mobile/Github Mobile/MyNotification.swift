//
//  MyNotification.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 11/4/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import Foundation
import UIKit

class MyNotification{
    var name : String //repository full_name
    var detail : String //subject title
    
    init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}
