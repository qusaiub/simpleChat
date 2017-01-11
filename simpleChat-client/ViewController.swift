//
//  ViewController.swift
//  Lesson 18 - Simple Chat Http Client
//
//  Created by Elad Lavi on 11/09/2016.
//  Copyright © 2016 HackerU LTD. All rights reserved.
//

import UIKit


extension URLSessionTask{
    func start(){
        self.resume();
    }
}

let baseUrl = "http://146.148.28.47/SimpleChatHttpServer/ChatServlet";
let margin:CGFloat = 15;

class ViewController: UIViewController, URLSessionDataDelegate, URLSessionDelegate {

    
    var txtUserName: UITextField!;
    var txtPassword: UITextField!;
    var btnLogin: UIButton!;
    var btnSignup: UIButton!;
    var lblStatus: UILabel!;
    var session: URLSession!;
    var userName: String!;
    var password: String!;
    var friendsViewController: FriendsViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let width:CGFloat = view.frame.width - margin*2;
        let height:CGFloat = 35;
        var yPos:CGFloat = 30;
        
        txtUserName = UITextField(frame: CGRect(x: margin, y: yPos, width: width, height: height));
        txtUserName.borderStyle = .roundedRect;
        txtUserName.placeholder = "user name..";
        view.addSubview(txtUserName);
        yPos += height + margin;
        txtPassword = UITextField(frame: CGRect(x: margin, y: yPos, width: width, height: height));
        txtPassword.isSecureTextEntry = true;
        txtPassword.placeholder = "password..";
        txtPassword.borderStyle = .roundedRect;
        yPos += height + margin;
        view.addSubview(txtPassword);
        
        btnLogin = UIButton(type: .system);
        btnLogin.frame = CGRect(x: margin, y: yPos, width: width/2, height: height);
        btnLogin.setTitle("login", for: UIControlState());
        btnLogin.addTarget(self, action: #selector(ViewController.btnLogin(_:)), for: .touchUpInside);
        btnLogin.tag = 1;
        view.addSubview(btnLogin);
        
        
        
        btnSignup = UIButton(type: .system);
        btnSignup.frame = CGRect(x: btnLogin.frame.maxX, y: yPos, width: width/2, height: height);
        btnSignup.setTitle("signup", for: UIControlState());
        btnSignup.addTarget(self, action: #selector(ViewController.btnLogin(_:)), for: .touchUpInside);
        btnSignup.tag = 2;
        view.addSubview(btnSignup);
        
        yPos += height + margin;
        
        lblStatus = UILabel(frame: CGRect(x: margin, y: yPos, width: width, height: height));
        lblStatus.textAlignment = .center;
        view.addSubview(lblStatus);
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil);
        
        
        //remove on production:
        txtUserName.text = "Aaa";
        txtPassword.text = "111";
    }
    
    func btnLogin(_ sender: UIButton){
        userName = txtUserName.text!;
        password = txtPassword.text!;
        if userName.isEmpty || password.isEmpty{
            lblStatus.text = "user name and password are required";
            lblStatus.textColor = UIColor.red;
            return;
        }
        lblStatus.text = "please wait...";
        lblStatus.textColor = UIColor.black;
        btnLogin.isEnabled = false;
        btnSignup.isEnabled = false;
        let action = sender.tag == 1 ? "login" : "signup";
        let url = URL(string: baseUrl)!;
        let httpRequest = NSMutableURLRequest(url: url);
        httpRequest.httpMethod = "POST";
        let dict:[String : String] = [
            "action" : action,
            "userName" : userName,
            "password" : password
        ];
        do{
            let d = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted);
            let task = session.uploadTask(with: httpRequest as URLRequest, from: d, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                
                DispatchQueue.main.async(execute: { 
                    [weak self] in
                    self!.btnLogin.isEnabled = true;
                    self!.btnSignup.isEnabled = true;
                })
                
                var gotResponse = false;
                if error == nil{
                    if let theData = data{
                        if theData.count > 0{
                            gotResponse = true;
                            do{
                                let dictResponse = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as! [String: String];
                                
                                let result = dictResponse["result"]!;
                                
                                DispatchQueue.main.async(execute: { 
                                    [weak self] in
                                    if result == "success"{
                                        self!.txtPassword.text = "";
                                        self!.txtUserName.text = "";
                                        self!.goToFriendsViewController();
                                        self!.lblStatus.text = "login ok";
                                        self!.lblStatus.textColor = UIColor.green;
                                    }else{
                                        DispatchQueue.main.async(execute: { 
                                            [weak self] in
                                            self!.lblStatus.text = "wrong username or password";
                                            self!.lblStatus.textColor = UIColor.red;
                                            
                                            })
                                    }
                                });
                            }catch{
                                DispatchQueue.main.async(execute: { 
                                    [weak self] in
                                    self!.lblStatus.text = "error desreializing the response";
                                    self!.lblStatus.textColor = UIColor.red;
                                    });
                            }
                            
                        }
                    }
                }
                if(!gotResponse){
                    DispatchQueue.main.async(execute: { 
                        [weak self] in
                        self!.lblStatus.text = "server error";
                        self!.lblStatus.textColor = UIColor.red;
                    })
                }
                }); 
            task.start();
        }catch{
            btnLogin.isEnabled = true;
            btnSignup.isEnabled = true;
            lblStatus.text = "error...";
            lblStatus.textColor = UIColor.red;
        }
        
        
        
    }
    
    func goToFriendsViewController(){
        if friendsViewController == nil{
            friendsViewController = FriendsViewController();
            friendsViewController.userName = userName;
            friendsViewController.password = password;
        }
        present(friendsViewController, animated: true, completion: nil);
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

