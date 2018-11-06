//
//  Person.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/27.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import Foundation
import UIKit

class Person{
    var name : String
    var login : String
    var location : String
    var avator : UIImage
    
    
    //create the person object
    init(name:String, login:String, location:String, avator:UIImage){
        self.name = name
        self.login = login
        self.location = location
        self.avator = avator
    }
}
