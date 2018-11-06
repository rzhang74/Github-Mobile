//
//  NotificationViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 11/4/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var notification_tableView: UITableView!
    
    var notifications : [MyNotification] = []
    var time = "Thu, 25 Oct 1997 15:16:27 GMT"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = self.notifications[indexPath.row]
        let notification_cell = tableView.dequeueReusableCell(withIdentifier: "notification_cell") as! NotificationTableViewCell
        notification_cell.setNotificationCell(notification: notification)
        return notification_cell
    }
    
    //make api calls to github and parse the data
    func createNot(){
        let urlString = "https://api.github.com/notifications"
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "token " + access_token, "If-Modified-Since":"Thu, 25 Oct 1997 15:16:27 GMT"]).responseJSON { response in
            print(response.response?.statusCode)
            if let json = response.result.value as? [[String: Any]] {
                for dict in json{
                    guard let repo = dict["repository"] as? [String : Any] else {return}
                    let name = repo["full_name"] as! String
                    guard let subject = dict["subject"] as? [String : Any] else {return}
                    let detail = subject["title"] as! String
//
                    let n = MyNotification(name: name, detail: detail)
                    self.notifications.append(n)
                }
                self.notification_tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.notifications = []
        createNot()
        //        URLCache.shared.removeAllCachedResponses()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
