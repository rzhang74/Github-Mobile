//
//  Repo.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/21.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import Foundation
import UIKit

class Repo{
    var project_name: String
    var detail : String
    var language : String
    var icon : UIImage
    var author : String
    var url : String
    
    //create the repository object
    init(project_name: String, detail: String, language: String, icon: UIImage, author: String){
        self.project_name = project_name
        self.detail = detail
        self.language = language
        self.icon = icon
        self.author = author
        self.url = ""
    }
}
