//
//  FriendsViewController.swift
//  Lesson 18 - Simple Chat Http Client
//
//  Created by Elad Lavi on 14/09/2016.
//  Copyright © 2016 HackerU LTD. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BackgroundDelegate {
    
    var userName: String!;
    var password: String!;
    var tblFriends: UITableView!;
    var friends: [Friend]!;
    var session: URLSession!;
    var chatViewController: ChatViewController!;
    var presented = true;
    var firstTime = true;
    var needsReload = false;
    var isInBackground = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = UIColor.white;
        friends = [Friend]();
        let frame = CGRect(x: 10, y: 30, width: view.frame.width - 10*2, height: view.frame.height - 10 - 30);
        tblFriends = UITableView(frame: frame, style: .plain);
        tblFriends.delegate = self;
        tblFriends.dataSource = self;
        view.addSubview(tblFriends);
        
        
        let configuration = URLSessionConfiguration.default;
        configuration.timeoutIntervalForRequest = 15.0;
        session = URLSession(configuration: configuration);
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.backgroundDelegate = self;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        presented = true;
        if firstTime{
            let url = URL(string: baseUrl)!;
            let request = NSMutableURLRequest(url: url);
            request.httpMethod = "POST";
            let dict:[String:String] = [
                "action" : "getUsers",
                "userName" : userName,
                "password" : password
            ];
            do{
                let d = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted);
                let task = session.uploadTask(with: request as URLRequest, from: d, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                    var gotData = false;
                    if error == nil{
                        if let theData = data{
                            if theData.count > 0{
                                gotData = true;
                                do{
                                    let result = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as! [String: AnyObject];
                                    let loadedUsers = result["users"] as! [String];
                                    var atLeastOneNew = false;
                                    for u in loadedUsers{
                                        var exists = false;
                                        for f in self!.friends{
                                            if f.userName == u{
                                                exists = true;
                                                break;
                                            }
                                        }
                                        if !exists{
                                            let f = Friend(userName: u);
                                            self!.friends.append(f);
                                            atLeastOneNew = true;
                                        }
                                    }
                                    if atLeastOneNew{
                                        DispatchQueue.main.async(execute: { 
                                            [weak self] in
                                            self!.tblFriends.reloadData();
                                            })
                                    }
                                    
                                }catch{
                                    print("error");
                                }
                            }
                        }
                    }else{
                        print("error loading friends from server");
                    }
                    
                    });
                task.start();
            }catch{
                print("error");
            }
            getMessages();
            firstTime = false;
        }else if needsReload{
            tblFriends.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier");
        }
        let friend = friends[(indexPath as NSIndexPath).row];
        cell!.textLabel!.text = friend.userName;
        if friend.messages.count > 0{
            cell!.detailTextLabel!.text = friend.messages[friend.messages.count-1].text;
        }
        if friend.hasNewMessages {
            cell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 16); 
        }else{
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 14);
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chatViewController == nil{
            chatViewController = ChatViewController();
            chatViewController.userName = userName;
            chatViewController.password = password;
        }
        chatViewController.friend = friends[(indexPath as NSIndexPath).row];
        present(chatViewController, animated: true, completion: nil);
        presented = false;
    }
    
    func getMessages(){
        let popTime = DispatchTime.now() + Double(Int64(NSEC_PER_SEC * 2)) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { 
            [weak self] in
            let request = NSMutableURLRequest(url: URL(string: baseUrl)!);
            request.httpMethod = "POST";
            let dict: [String: String] = [
                "action" : "getMessages",
                "userName" : self!.userName,
                "password" : self!.password
            ];
            do{
                let d = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted);
                let task = self!.session.uploadTask(with: request as URLRequest, from: d, completionHandler: { [weak self](data: Data?, response: URLResponse?, error: Error?) in
                    if error == nil{
                        if let theData = data{
                            if theData.count > 0{
                                do{
                                    let result = try JSONSerialization.jsonObject(with: theData, options: .allowFragments) as! [String: AnyObject];
                                    let messages = result["messages"] as! NSArray;
                                    for m in messages{
                                        let msg = m as! [String:String];
                                        let text = msg["text"]!;
                                        let sender = msg["sender"]!;
                                        var isExistingFriend = false;
                                        for friend in self!.friends{
                                            if friend.userName == sender{
                                                friend.messages.append(Message(text: text, sender: sender, recipient: self!.userName));
                                                friend.hasNewMessages = true;
                                                isExistingFriend = true;
                                                break;
                                            }
                                        }
                                        if !isExistingFriend {
                                            let friend = Friend(userName: sender);
                                            friend.messages.append(Message(text: text, sender: sender, recipient: self!.userName));
                                            friend.hasNewMessages = true;
                                            self!.friends.append(friend);
                                        }
                                    }
                                    if messages.count > 0{
                                        if self!.presented{
                                            DispatchQueue.main.async(execute: { 
                                                [weak self] in
                                                self!.tblFriends.reloadData();
                                                });
                                        }else{
                                            self!.needsReload = true;
                                            if !self!.isInBackground{
                                                if self!.chatViewController != nil{
                                                    DispatchQueue.main.async {
                                                        [weak self] in
                                                        self!.chatViewController.refreshMessages();
                                                        //TODO: refresh only if chatting with a friend that got new message
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if !self!.isInBackground{
                                        self!.getMessages();
                                    }
                                    print("checked messages");
                                }catch{
                                    print("error processing messages response");
                                }
                            }
                        }
                    }
                    });
                task.start();
            }catch{
                print("error getting messages");
            }
            
        }
    }
    
    func didEnterBackground() {
        presented = false;
        isInBackground = true;
    }
    
    func didEnterForeground() {
        isInBackground = false;
        getMessages();
    }
}
