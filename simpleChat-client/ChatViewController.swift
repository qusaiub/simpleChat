//
//  ChatViewController.swift
//  Lesson 18 - Simple Chat Http Client
//
//  Created by Elad Lavi on 14/09/2016.
//  Copyright © 2016 HackerU LTD. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, URLSessionDataDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var userName: String!;
    var password: String!;
    var friend: Friend!;
    var session: URLSession!;
    var btnBack: UIButton!;
    var txtMessage: UITextField!;
    var btnSend: UIButton!;
    var lblStatus: UILabel!;
    var tblMessages: UITableView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.white;
        btnBack = UIButton(type: .system);
        btnBack.frame = CGRect(x: margin, y: 25, width: 200, height: 25);
        btnBack.setTitle("<-back", for: .normal);
        btnBack.sizeToFit();
        btnBack.addTarget(self, action: #selector(ChatViewController.btnBack(_:)), for: .touchUpInside);
        view.addSubview(btnBack);
        
        btnSend = UIButton(type: .system);
        btnSend.setTitle("send", for: .normal);
        btnSend.frame = CGRect(x: view.frame.width-60-margin, y: view.frame.height-30-margin, width: 60, height: 30);
        btnSend.addTarget(self, action: #selector(ChatViewController.btnSend(_:)), for: .touchUpInside);
        view.addSubview(btnSend);
        
        txtMessage = UITextField(frame: CGRect(x: margin, y: btnSend.frame.origin.y, width: view.frame.width - 3*margin - btnSend.frame.width, height: btnSend.frame.height));
        txtMessage.borderStyle = .roundedRect;
        view.addSubview(txtMessage);
        
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil);
        
        lblStatus = UILabel(frame: CGRect(x: btnBack.frame.maxX + margin, y: btnBack.frame.origin.y, width: 300, height: btnBack.frame.height));
        view.addSubview(lblStatus);
        
        let tableFrame = CGRect(x: margin, y: btnBack.frame.maxY + margin, width: view.frame.width - 2*margin, height: view.frame.height - btnBack.frame.height - btnSend.frame.height - 3*margin - 30);
        tblMessages = UITableView(frame: tableFrame, style: .plain);
        tblMessages.delegate = self;
        tblMessages.dataSource = self;
        view.addSubview(tblMessages);
        
        
        
    }
    
    func refreshMessages(){
        tblMessages.reloadData();
    }
    
    func btnSend(_ sender: UIButton){
        if txtMessage.hasText{
            let message = txtMessage.text!;
            btnSend.isEnabled = false;
            txtMessage.isEnabled = false;
            btnSend.setTitle("wait..", for: .normal);
            var dict : [String: String] = [
                "action" : "sendMessage",
                "userName" : userName,
                "password" : password,
                "text" : message,
                "recipient" : friend.userName
            ];
            do{
                let d = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted);
                
                let urlRequest = NSMutableURLRequest(url: URL(string: baseUrl)!);
                
                urlRequest.httpMethod = "POST";
                let task = session.uploadTask(with: urlRequest as URLRequest, from: d, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                    DispatchQueue.main.async {
                        [weak self] in
                        self!.btnSend.isEnabled = true;
                        self!.txtMessage.isEnabled = true;
                        self!.btnSend.setTitle("send", for: .normal);
                    }
                    if error == nil{
                        if let theData = data{
                            if theData.count > 0{
                                do{
                                    let jsonResponse = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as! [String: String];
                                    let result = jsonResponse["result"];
                                    print("message sent: \(result)");
                                    DispatchQueue.main.async {
                                        [weak self] in
                                        if result == "success"{
                                            self!.txtMessage.text = "";
                                            self!.lblStatus.text = "sent..";
                                            self!.lblStatus.textColor = UIColor.green;
                                            self!.friend.messages.append(Message(text: message, sender: self!.userName, recipient: self!.friend.userName));
                                            self!.tblMessages.reloadData();
                                    }else{
                                        self!.lblStatus.text = "error sending";
                                        self!.lblStatus.textColor = UIColor.red;
                                        
                                    }
                                }
                                }catch{
                                    
                                }
                            }
                        }
                    }
                    
                });
                task.start();
                
                
            }catch{
                print("error");
            }
        }
    }
    
    func btnBack(_ sender: UIButton){
        dismiss(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend.messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier");
        }
        let message = friend.messages[indexPath.row];
        cell!.textLabel!.text = message.text;
        if message.sender == self.userName {
            cell!.textLabel!.textColor = UIColor.green;
        }else{
            cell!.textLabel!.textColor = UIColor.darkGray;
        }
        return cell!;
    }
    
}
