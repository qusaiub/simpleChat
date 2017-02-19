//
//  AlbumCell.swift
//  IndieMusic
//
//  Created by Admin on 2/15/17.
//  Copyright © 2017 Mfortis. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblSongTime: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblAlbumName: UILabel!

    @IBOutlet weak var pageController: UIPageControl!
    
    
    
   
    func SetMyCell(album:A){
        
        if let url = NSURL(string: album.image){
            if let data = NSData(contentsOf: url as URL){
                imgAlbum.contentMode = .scaleAspectFill
                imgAlbum.layer.cornerRadius = 27
                imgAlbum.layer.borderWidth = 1
                imgAlbum.layer.masksToBounds = true
                print("\(album.image)")
                imgAlbum.image = UIImage(data: data as Data)
            }
        }
        self.pageController.numberOfPages = album.songs.count
        
        for i in 0..<album.songs.count{
            
            if album.songs[i].selected{

                self.lblSongName.text = album.songs[i].song
                self.lblSongTime.text = album.songs[i].duration
                self.pageController.currentPage = i

         
            }
        }
        
        self.lblAlbumName.text = album.album
        self.lblArtistName.text = album.artist
        
    }

}



