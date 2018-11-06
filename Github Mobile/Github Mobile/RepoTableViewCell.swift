//
//  RepoTableViewCell.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/21.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var vis: UIButton!
    @IBOutlet weak var project_name: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var backgroundCard: UIView!
    
    //given a repository object, turn it into corresponding cell
    func setRepoCell(repo : Repo){
        project_name.text = repo.project_name
        detail.text  = repo.detail
        language.text = repo.language
        author.text = repo.author
        icon.image = repo.icon
        
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
