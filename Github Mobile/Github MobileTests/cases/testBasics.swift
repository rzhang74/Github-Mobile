//
//  testProfile.swift
//  Github MobileTests
//
//  Created by 张瑞麟 on 10/29/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import XCTest

@testable import Pods_Github_Mobile

class testProfile: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerson(){

        let p = Person(name: "hi", login: "cs242", location: "u", avator: UIImage())
        XCTAssertEqual("hi", p.name)
        XCTAssertEqual("cs242", p.login)
        XCTAssertEqual("u", p.location)
        
    }
    
    func testRepo(){
        
        let r = Repo(project_name: "1", detail: "2", language: "3", icon: UIImage(), author: "4")
        XCTAssertEqual("1", r.project_name)
        XCTAssertEqual("2", r.detail)
        XCTAssertEqual("3", r.language)
        XCTAssertEqual("4", r.author)
    }
    
    func testRepoGet(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "1") as! ReposViewController
        //let vc = ReposViewController()
        //_ = vc.view
    }
    


}
