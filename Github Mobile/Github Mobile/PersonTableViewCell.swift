//
//  PersonTableViewCell.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/27.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import UIKit
import Alamofire

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!

    
    @IBOutlet weak var backgroundCard2: UIView!
    @IBOutlet weak var backgroundCard: UIView!
    
    @IBOutlet weak var Unfollow: UIButton!
    @IBOutlet weak var Follow: UIButton!
    //    follow.setTitle("unfollow", for: .normal)

    //given a person object, turn it into corresponding cell
    func setPersonCell(person : Person){
            avatar.image = person.avator
            login.text = person.login
            name.text = person.name
            location.text = person.location
        
        
            contentView.backgroundColor = UIColor(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
            
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
