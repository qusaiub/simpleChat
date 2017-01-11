//
//  Friend.swift
//  Lesson 18 - Simple Chat Http Client
//
//  Created by Elad Lavi on 14/09/2016.
//  Copyright © 2016 HackerU LTD. All rights reserved.
//

import Foundation


class Friend {
    var userName: String;
    var messages: [Message];
    var hasNewMessages = false;
    
    init(userName: String){
        self.userName = userName;
        messages = [Message]();
    }
}