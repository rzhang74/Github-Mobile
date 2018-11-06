//
//  FollowerViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/27.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase

class FollowerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var follower_tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searching = false
    var search : [Person] = []
    var people : [Person] = []
    var fref: DatabaseReference!
    
    //num of rows of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return self.search.count
        }
        return self.people.count
    }
    
    //make api request to follow people
    @objc func onButtonClicked(_ sender: UIButton) {
        let apiURLString = "https://api.github.com/user/following/" + people[sender.tag].login+"?client_id="+key+"&client_secret="+secret
        print(apiURLString)
        print("token " + access_token)
        Alamofire.request(apiURLString, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "token " + access_token]).responseJSON { response in
            print(response.response?.statusCode)
        }
    

        sender.setTitle("unfollow", for: .normal)
    }
    
    //return the table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var person : Person
        if searching {
            person = self.search[indexPath.row]
        }else{
            person = self.people[indexPath.row]
        }
        let person_cell = tableView.dequeueReusableCell(withIdentifier: "follower_cell") as! PersonTableViewCell
        person_cell.setPersonCell(person: person)
        person_cell.backgroundCard.backgroundColor = UIColor.white
        person_cell.backgroundCard.layer.cornerRadius=3.0
        person_cell.backgroundCard.layer.masksToBounds=false
        person_cell.backgroundCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        person_cell.backgroundCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        person_cell.backgroundCard.layer.shadowOpacity = 0.8
        
        let b = person_cell.Follow
        b?.isUserInteractionEnabled = true
        b?.tag = indexPath.row
        b?.addTarget(self, action: #selector(onButtonClicked(_:)), for: .touchUpInside)

        return person_cell
    }
    
    //cell clicked response link to profile page
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "profile", sender: self)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "0") as! UITabBarController
        self.present (vc, animated: true, completion: nil)
        username = self.people[indexPath.row].login
        vc.selectedIndex = 0
//        vc.pushToViewController(profile, animated: true)
    }
    
    //cell animation
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
//        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)//CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
//        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    //make api request to get followers of login
    func createfollowers(){
        self.people = []
        print("usernamefo: " + username)
        Alamofire.request("https://api.github.com/users/" + username + "/followers?per_page=10"+"?client_id="+key+"&client_secret="+secret).responseJSON { response in
            if let json = response.result.value as? [[String: Any]] {
                //name, description, language
                for dict in json{
                    let login = (dict["login"] is NSNull ? "" : dict["login"]!) as! String
                    Alamofire.request("https://api.github.com/users/"+login+"?client_id="+key+"&client_secret="+secret).responseJSON { response in
                        if let dict = response.result.value as? [String: Any] {
                            print(login)
                            let name = (dict["name"] is NSNull ? "" : dict["name"]) as! String
                            let location = (dict["location"] is NSNull ? "" : dict["location"]) as! String
                            let avatar_url = (dict["avatar_url"] is NSNull ? "" : dict["avatar_url"]!) as! String
                            
                            let url = URL(string: avatar_url)
                            let data = try? Data(contentsOf: url!)
                            let avatar = UIImage(data: data!)!
  
                            let p = Person(name: name, login: login, location: location, avator: avatar)
                            let ref = self.fref.child(username.lowercased()+"_followedby_"+login.lowercased())
                            ref.setValue(["follower_name":name, "follower_loc":location, "follower_login":login])
                            self.people.append(p)
                            self.follower_tableView.reloadData()
                        }
                    }
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("followerpage-refresh")
        createfollowers()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        self.fref = Database.database().reference(withPath: "follower")
        // Do any additional setup after loading the view.
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

extension FollowerViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        search = people.filter( {$0.login.contains(searchText)} )
        search = search.sorted { $0.login < $1.login }
        if searchText == "" {
            searching = false
        }
        self.follower_tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searching = false
        searchBar.text = ""
        search = []
        self.follower_tableView.reloadData()
    }
}

