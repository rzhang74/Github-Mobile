//
//  ProfileViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/20.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase

var username = "rzhang74"

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var Home: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var repo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var login_name: UILabel!
    @IBOutlet weak var noRepo: UILabel!
    @IBOutlet weak var noFollower: UILabel!
    @IBOutlet weak var noFollowing: UILabel!
    @IBOutlet weak var locationAddr: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var profileref: DatabaseReference!
    var data = ["Github username", "Bio", "Email", "Profile create date"]
    var dataDetail = ["", "", "", ""]
    
    //go back your main page
    @IBAction func clickHome(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "0") as! UITabBarController
        self.present (vc, animated: true, completion: nil)
        username = main_user
        vc.selectedIndex = 0
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    //set cell height
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 94.0
    }
    
    //set number of cells
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    //configure the cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
 
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(17.0)
        cell.detailTextLabel?.text = dataDetail[indexPath.row]
        cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(16.0)
        
        cell.selectionStyle = .none //make cell unselectable
        
        return cell
    }
    
    //configure the cell animation
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
    }

    //make github api calls and parse the data(store in app)
    func loadData(){
        Alamofire.request("https://api.github.com/users/" + username+"?client_id="+key+"&client_secret="+secret).responseJSON { response in
            if let dict = response.result.value as? [String: Any] {
                //name, description, language
                self.dataDetail[0] = (dict["name"] is NSNull || dict["name"] == nil ? "" : dict["name"]!) as! String
                self.dataDetail[1] = (dict["bio"] is NSNull || dict["bio"] == nil ? "" : dict["bio"]) as! String
                self.dataDetail[2] = (dict["email"] is NSNull || dict["email"] == nil ? "" : dict["email"]!) as! String
                self.dataDetail[3] = (dict["created_at"] is NSNull || dict["created_at"] == nil ? "" : String((dict["created_at"]! as! String).dropLast(10)))
                
                self.login_name.text = ((dict["login"] is NSNull || dict["login"] == nil ? "" : dict["login"]!) as! String)
                self.locationAddr.text = ((dict["location"] is NSNull || dict["location"] == nil ? "" : dict["location"]) as! String)
                self.noRepo.text = ((dict["public_repos"] is NSNull || dict["public_repos"] == nil ? "" : "\(String(describing: dict["public_repos"]!))") )
                self.noFollower.text = ((dict["followers"] is NSNull || dict["followers"] == nil ? "" : "\(String(describing: dict["followers"]!))") )
                self.noFollowing.text = ((dict["following"] is NSNull || dict["following"] == nil ? "" : "\(String(describing: dict["following"]!))") )
                
                let avatar_url = (dict["avatar_url"] is NSNull || dict["avatar_url"] == nil ? "" : dict["avatar_url"]!) as! String
                
                if(avatar_url == ""){
                    let avatar = UIImage()
                }else{
                    let url = URL(string: avatar_url)
                    let data = try? Data(contentsOf: url!)
                    let avatar = UIImage(data: data!)!
                    self.image.image = avatar
                }
                
                if(self.login_name.text!.lowercased() != ""){
                    let profileItemRef = self.profileref.child(self.login_name.text!.lowercased())
                    profileItemRef.setValue(["name":self.dataDetail[0], "bio":self.dataDetail[1], "email":self.dataDetail[2],  "login":self.login_name.text,  "location":self.locationAddr.text, "noRepo":self.noRepo.text, "noFollower":self.noFollower.text,"noFollowing":self.noFollowing.text])
                }
                
                
                self.profileView.reloadInputViews()
                self.tableView.reloadData()
            }
        }
    }
    
    //repository tap gesture respond
    @objc func repoHandleTap(sender:UITapGestureRecognizer){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "2") as UIViewController
        self.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    //following tap gesture respond
    @objc func followingHandleTap(sender:UITapGestureRecognizer){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "3") as UIViewController
        self.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    //follower tap gesture respond
    @objc func followerHandleTap(sender:UITapGestureRecognizer){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "4") as UIViewController
        self.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //important for making search bar funciton to work
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.repo.isUserInteractionEnabled = true
        self.follower.isUserInteractionEnabled = true
        self.following.isUserInteractionEnabled = true
        self.repo.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.repoHandleTap)))
        self.follower.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.followingHandleTap)))
        self.following.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.followerHandleTap)))
        
        self.profileref = Database.database().reference(withPath: "profile")
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.text = ""
    }
}


