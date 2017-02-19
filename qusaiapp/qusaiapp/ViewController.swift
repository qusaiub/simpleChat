import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var albums:[A] = [A]()
    var myAlbums:[A] = [A]()
    var counter = 0
    var button:UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        albums = H.getA()
        
        let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(self.Sleft(gesture:)))
        swipeR.direction = UISwipeGestureRecognizerDirection.right
        tableView.addGestureRecognizer(swipeR)
        
        
        let swipeL = UISwipeGestureRecognizer(target: self, action: #selector(self.Sright(gesture:)))
        swipeL.direction = UISwipeGestureRecognizerDirection.left
        tableView.addGestureRecognizer(swipeL)
        
        button = UIButton(type: .system)
        button = UIButton(frame: CGRect(x: 0, y: view.frame.width/3, width: view.frame.width/2, height: 3))
        button.setTitle("Check", for: .normal)
        
        
        
        
        
        
    }
    
    
    
   
    
    
    //MARK: Table View Delegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AlbumCell
        
        
        cell.SetMyCell(album: myAlbums[indexPath.row])
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func Sright(gesture: UISwipeGestureRecognizer){
        
        var number = 0
        var lastSelectedSong = 0
        var selectedSong = 0
        
        let swipeLocation = gesture.location(in: self.tableView)
        if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
            
            number = swipedIndexPath.row
        }
        
        
        print("Gesture tag \(number)")
        
        for i in 0..<myAlbums[number].songs.count {
            
            if myAlbums[number].songs[i].selected {
                selectedSong = i
                lastSelectedSong = i
            }
        }
        
        
        if selectedSong != myAlbums[number].songs.count - 1 {
            
            for i in 0..<myAlbums[number].songs.count {
                
                if myAlbums[number].songs[i].selected {
                    myAlbums[number].songs[i].selected = false
                }
            }
            
            
            if lastSelectedSong < myAlbums[number].songs.count - 1 {
                
                lastSelectedSong += 1
                myAlbums[number].songs[lastSelectedSong].selected = true
            }
            
            tableView.reloadData()
        }
        
        
        
        
    }
    
    func Sleft(gesture: UISwipeGestureRecognizer){
        
        
        var number =  0
        var lastSelected = 0
        var selecteded = 0
        
        
        
        let swipeLocation = gesture.location(in: self.tableView)
        if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
            
            number = swipedIndexPath.row
        }
        
        print("Gesture tag \(number)")
        
        for i in 0..<myAlbums[number].songs.count {
            
            if myAlbums[number].songs[i].selected {
                selecteded = i
                lastSelected = i
            }
        }
        
        
        if selecteded != 0 {
            
            for i in 0..<myAlbums[number].songs.count {
                
                if myAlbums[number].songs[i].selected {
                    
                    myAlbums[number].songs[i].selected = false
                }
            }
            
            lastSelected -= 1
            myAlbums[number].songs[lastSelected].selected = true
            
            
            tableView.reloadData()
        }
    }
    
    func sortdata(t:A, c:A) -> Bool {
        return t.artist < c.artist
    }
    
    @IBAction func addAlbum(_ sender: Any) {
        
        if counter < albums.count {
            
            myAlbums.removeAll()
            
            var albumsCount = 0
            
            while albumsCount <= counter {
                myAlbums.append(albums[albumsCount])
                albumsCount += 1
            }
            
            myAlbums.sort(by: sortdata)
            counter += 1
            tableView.reloadData()
            
        }
        
    }
    
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
    
}
