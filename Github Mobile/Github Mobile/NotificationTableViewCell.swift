//
//  NotificationTableViewCell.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 11/4/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func setNotificationCell(notification : MyNotification){
        nameLabel.text = notification.name
        detailLabel.text  = notification.detail

        backgroundCard.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(displayP3Red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)

        backgroundCard.layer.cornerRadius=3.0
        backgroundCard.layer.masksToBounds=false
        backgroundCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        backgroundCard.layer.shadowOpacity = 0.8
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
