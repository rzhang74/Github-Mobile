//
//  ReposViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 2018/10/21.
//  Copyright © 2018年 张瑞麟. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import Charts

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searching = false
    var repos : [Repo] = []
    var search : [Repo] = []
    var image_dict : [String:UIImage] = ["Swift":#imageLiteral(resourceName: "swift"), "Java":#imageLiteral(resourceName: "java"), "Python":#imageLiteral(resourceName: "python"), "JavaScript":#imageLiteral(resourceName: "javascript"), "Haskell":#imageLiteral(resourceName: "haskell")]
    var reporef : DatabaseReference!

    @IBOutlet weak var repo_tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //set number of cells
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.search.count
        }
        return self.repos.count
    }
    
    //configuret the repo cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var repo : Repo
            if searching {
               repo = self.search[indexPath.row]
            }else{
               repo = self.repos[indexPath.row]
            }
            let repo_cell = tableView.dequeueReusableCell(withIdentifier: "repo_cell") as! RepoTableViewCell
            repo_cell.setRepoCell(repo: repo)
        
            let v = repo_cell.vis
            v?.isUserInteractionEnabled = true
            v?.tag = indexPath.row
            v?.addTarget(self, action: #selector(onButtonClicked(_:)), for: .touchUpInside)
        
            return repo_cell
    }
    
    @objc func onButtonClicked(_ sender: UIButton) {
        let apiURLString = "https://api.github.com/repos/" + username + "/" + repos[sender.tag].project_name + "/commits" + "?client_id="+key+"&client_secret="+secret
        print(apiURLString)
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "6") as! PopUpViewController
        
        //add chart
        let time = ["0-4am", "4-8am", "8-12am", "12-4pm", "4-8pm", "8pm-0am"]
        var time_val = [Int](repeating: 0, count: 6)
        let month = ["Jan-Mar", "Mar-May", "May-Jul", "Jul-Sep", "Sep-Nov", "Nov-Jan"]
        var month_val = [Int](repeating: 0, count: 6)
        
        Alamofire.request(apiURLString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "token " + access_token]).responseJSON { response in
            print(response.response?.statusCode)
            if let json = response.result.value as? [[String: Any]] {
                for dict in json{
                    guard let commit = dict["commit"] as? [String : Any] else {return}
                    guard let author = commit["author"] as? [String : Any] else {return}
                    let date = author["date"] as!String
                    let idx1 = Int(String(date[11..<13]))! / 4 as Int
                    time_val[idx1] = time_val[idx1] + 1
                    let idx2 = (Int(String(date[5..<7]))! - 1) / 2 as Int
                    month_val[idx2] = month_val[idx2] + 1
                }
            }
            
            popVC.time = time
            popVC.time_val = time_val
            popVC.month = month
            popVC.month_val = month_val
            
            self.addChildViewController(popVC)
            popVC.view.frame = self.view.frame
            self.view.addSubview(popVC.view)
            popVC.didMove(toParentViewController: self)
        }

    }
    
    //cell animation
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)//CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
    
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    //click respond(open github url) for selecting the cell
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(repos[indexPath.row].url)
        let url = repos[indexPath.row].url
        if url != ""{
            guard let url = URL(string: url) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //make api calls to github and parse the data
    func createRepos(){
        self.repos = []
        print(username)
        Alamofire.request("https://api.github.com/users/" + username + "/repos"+"?client_id="+key+"&client_secret="+secret).responseJSON { response in
            if let json = response.result.value as? [[String: Any]] {
                //name, description, language
                for dict in json{
                    let project_name = (dict["name"] is NSNull ? "" : dict["name"]!) as! String
                    let detail = (dict["description"] is NSNull ? "" : dict["description"]) as! String
                    let language = (dict["language"] is NSNull ? "" : dict["language"]!) as! String
                    let author_dict = dict["owner"] as? [String: Any]
                    let author = (author_dict!["login"] is NSNull ? "" : author_dict!["login"]) as! String
                    let icon = (self.image_dict[language] == nil ? #imageLiteral(resourceName: "haskell") : self.image_dict[language]) as! UIImage
                    
                    let r = Repo(project_name: project_name, detail: detail, language: language, icon: icon, author: author)
                    
                    let ref = self.reporef.child(r.project_name.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil))
                    ref.setValue(["project_name":project_name, "detail":detail, "language":language,"author":author])
                    
                    r.url = (dict["html_url"] is NSNull ? "" : dict["html_url"]) as! String
                    self.repos.append(r)
                }
                
                self.repo_tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        createRepos()

        repo_tableView.rowHeight = UITableViewAutomaticDimension
        repo_tableView.estimatedRowHeight = 130
        
        self.reporef = Database.database().reference(withPath: "repo")
        
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

extension ReposViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.endEditing(false)
        print("hi")
        searching = true
        search = repos.filter( {$0.project_name.contains(searchText)} )
        search = search.sorted { $0.language < $1.language }
        print(searchText)
        if searchText == "" {
            searching = false
        }
        self.repo_tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searching = false
        searchBar.text = ""
        search = []
        self.repo_tableView.reloadData()
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
