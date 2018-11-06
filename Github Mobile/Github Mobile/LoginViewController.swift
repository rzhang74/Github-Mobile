//
//  LoginViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 10/28/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import UIKit
import OAuthSwift
import Alamofire

var access_token = ""
var main_user = ""
var key = "d9addcf90c7509635d87"
var secret = "faba3777ac90d666c419d714c379f49aa72162e9"

class LoginViewController: UIViewController, UINavigationControllerDelegate {

    var oauthswift: OAuthSwift?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //login action
    @IBAction func login(_ sender: Any) {
        let oauthswift = OAuth2Swift(
            consumerKey:    "d9addcf90c7509635d87",
            consumerSecret: "faba3777ac90d666c419d714c379f49aa72162e9",
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "com.raywenderlich.Incognito://oauth2Callback")!, scope: "user,repo", state: state,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                access_token = credential.oauthToken
                
                Alamofire.request("https://api.github.com/user?access_token=" + access_token).responseJSON { response in
                    if let dict = response.result.value as? [String: Any] {
                        main_user = dict["login"] as! String
                        username = main_user
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                    }
                }
                
        },
            failure: { error in
                print(error.description)
        }
        )
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
