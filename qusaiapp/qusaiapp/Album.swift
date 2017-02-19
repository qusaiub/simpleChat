//
//  Album.swift
//  IndieMusic
//
//  Created by Admin on 2/15/17.
//  Copyright © 2017 Mfortis. All rights reserved.
//

import UIKit

class A: NSObject {
    
    var album = ""
    var genre  = ""
    var image = ""
    var songs  = [Songs]()
    var artist = ""

    
    init(object:[String:AnyObject]) {
        
        self.album = object["album"] as! String
        self.artist = object["artist"] as! String
        self.image = object["image"] as! String
        self.genre = object["genre"] as! String
        
        
        for o in object["songs"] as! [[String:AnyObject]]{
            
            songs.append(Songs(object: o))
            
        }
    }
    
}



class Songs:NSObject {
    
    var duration  = ""
    var song      = ""
    var selected  = false
    
    init(object:[String:AnyObject]) {
        
        self.song     = object["song"] as! String
        self.duration = object["duration"] as! String
        
        
    }
    
}
