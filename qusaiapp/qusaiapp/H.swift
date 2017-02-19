//
//  H.swift
//  qusaiapp
//
//  Created by Admin on 2/19/17.
//  Copyright © 2017 Mfortis. All rights reserved.
//

import Foundation

import UIKit

class H: NSObject {
    
    
    class func getA() -> [A]{
        
        var album = [A]()
        
        if let url = Bundle.main.url(forResource: "indie_music", withExtension: ".json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: [])
                    
                    let data = object as! [[String:AnyObject]]
                    
                    
                    
                    for i in 0..<data.count {
                        
                        album.append(A(object: data[i]))
                        
                        album[i].songs[0].selected = true
                        
                    }
                    
                    
                    
                   
                    
                } catch {
                    
                }
            }
            
        }
        return album
    }
    
}
