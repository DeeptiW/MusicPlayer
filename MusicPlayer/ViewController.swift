//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 05/07/18.Ô
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit
import CoreData

class AudioListTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout>
        (dataSourceDelegate: D, forSection section: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        collectionView.reloadData()
    }
    
    
}

class HeaderTableCell: UITableViewCell {
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var title: UILabel!
}



struct Album {
    init() {
    }
    var url       : URL?
    var title     : String?
    var author    : String?
    var thumbnail : Data?
    var isPlay    : Bool?
    var audioName : String?
}


class ViewController: UIViewController {

    //var audioFileArray   = [URL]()
    
    var isGrid           = true
  
    //var fetchAudioDetails : [NSManagedObject] = []
    
    
    @IBOutlet weak var audioTable: UITableView!
    let layout = UICollectionViewFlowLayout()
   
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    private let dataModel = PlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        searchBar.placeholder = "Search Music & Artists"
        navigationItem.titleView = searchBar
        audioTable.tableFooterView = UIView()
        
        managedContext = appDelegate?.persistentContainer.viewContext
        

        //Get document directory
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        docPath = "\(documentsURL)"
        print("Save Audios in documents directory : \(documentsURL)")
        
        
        
        //
        SingletonMusicPlayer.shared.customView?.playPauseBtn
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Retrieve audio file
        retrieveAudioFile()
        self.audioTable.reloadData()
    }
    
    @IBAction func rightBarBtnAction(_ sender: Any) {
        
    }
    
    
  
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
       // queueAudioPlayer()
    }
    

   
}




//MARK:- CollectionView Delegate/Datasource
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return fetchDetails.count
        return allAudioListArray[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let audioDetails = allAudioListArray[collectionView.tag][indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        
        /*cell.thumbnail.image = UIImage(data: audioDetails.value(forKey: "thumbnail") as! Data)
        
        if albumArray[indexPath.row].isPlay! {
            cell.playBtn.image = #imageLiteral(resourceName: "pause")
        }else{
            cell.playBtn.image = #imageLiteral(resourceName: "play")
        }
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)*/
        
        
        
        //todo : long press edition
        /*let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(editAction(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        collectionView.addGestureRecognizer(lpgr)*/
        
        cell.thumbnail.image = UIImage(data: audioDetails.thumbnail! as Data)!
        
        return cell
        
        
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // showView()
        if isPlay && currentSongIndex == indexPath.row{
            isPlay = false
            player?.pause()
          //  playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)//hide bottom bar
            //albumArray[indexPath.row].isPlay = false
           // audioCollectionView.reloadData()
           // NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: nil, userInfo: ["play": false])
           // NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: false)

            return
        }
        
        if isPlay && currentSongIndex != indexPath.row{
           // albumArray[currentSongIndex].isPlay = false
           // albumArray[indexPath.row].isPlay    = true
           // playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
          //  NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: nil, userInfo: ["play": true])
           //NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: true)


        }
        
        if !isPlay{
          //  playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
          //  albumArray[indexPath.row].isPlay = true
         //   NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: nil, userInfo: ["play": true])
          //  NotificationCenter.default.post(name: Notification.Name("PlayPause"), object: true)

            isPlay = true
        }
        
       // playUsingAVPlayer(url: audioFileArray[indexPath.row])
       // currentSongIndex = indexPath.row
       // audioCollectionView.reloadData()
        
        
        //
        
       
        
        isPlay               = true // before run check
        currentSongIndex     = indexPath.row
        currentCollectionTag = collectionView.tag
        SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
       
        
    }
    
    //Set collection view grid
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    
    
    
    //MARK:- Edit Details
    @objc func editAction(gestureReconizer: UILongPressGestureRecognizer)  {

        /*if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let point = gestureReconizer.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(point)
        
        if let index = indexPath {
            var cell = self.collectionView.cellForItemAtIndexPath(index)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
        } else {
            print("Could not find index path")
        }
        
        
        let audioFileEditController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioFileEditController") as? AudioFileEditController
        let editBtn = sender as! UIButton
        audioFileEditController?.audioFile = fetchDetails[editBtn.tag]
        self.navigationController?.pushViewController(audioFileEditController!, animated: true)*/
    }
    
    
   /* @objc func moreBtnAction(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let playAction = UIAlertAction(title: "Play Now", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Play song")
          //  self.playAudioAction(sender)
        })
        let playlistAction = UIAlertAction(title: "Add To Playlist", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
         //   self.addToPlayListAction(sender)
        })
        let editPlaylistAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.editAction(sender)
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        optionMenu.addAction(playAction)
        optionMenu.addAction(playlistAction)
        optionMenu.addAction(editPlaylistAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }*/
}

//MARK:- Retrieve Audio From DD
extension ViewController {
   
    //Store and retrieve from dd
    func retrieveAudioFile()  {
        fetchFromCoreData { (true) in
            if fetchDetails.count > 0{
                self.storeAlbumList()
            }else{
                SingletonMusicPlayer.shared.getFilesFromDD(completion: { (true) in
                    storeIncoreData { (true) in
                        fetchFromCoreData(completion: { (true) in
                            self.storeAlbumList()
                            self.audioTable.reloadData()
                        })
                    }
                })
            }
        }
    }
    
    
    func storeAlbumList()   {
        //MARK:- All Audio Array
        allAudioListArray.removeAll()
        let audioSongs =  fetchDetails as! [AudioFile]
        allAudioListArray.append(audioSongs)
        
        fetchPlaylist(entityName: "AudioPlaylist") { (true) in
            for playlist in fetchAuiodDetails {
                let audioList = playlist as! AudioPlaylist
                let playlistAudioSongs = audioList.audioFile
                let myArray = Array(playlistAudioSongs!)
                let temp = myArray as! [AudioFile]
                allAudioListArray.append(temp)
            }
        }
        self.audioTable.reloadData()
    }
    
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
       if fetchAuiodDetails.count > 0 {
            return 1 + fetchAuiodDetails.count
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchAuiodDetails.count == 0 && section == 1{
            return 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioListCell", for: indexPath) as! AudioListTableCell
        //cell.collectionView.tag = indexPath.section
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
        
        
        
        return cell
    }
    
    //MARK: Table Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableCell
        
        switch section {
        case 0:
            cell.title.text = "All"
        default:
            
            if fetchAuiodDetails.count > 0{
                let playList = fetchAuiodDetails[section-1]
                cell.title.text = playList.value(forKey: "playlistName") as? String
                
                if fetchAuiodDetails.count == 0 {
                    cell.moreBtn.isHidden = true
                }
            }else{
                cell.title.text = "playlistName"
                cell.moreBtn.isHidden = true
            }
        }
        
        cell.moreBtn.tag = section
        cell.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    //MARK:
    @objc func moreBtnAction(_ sender: Any){
        //let moreBtn = sender as! UIButton
        let audioFileEditController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioListViewController") as? AudioListViewController
        let moreBtn = sender as! UIButton
        audioFileEditController?.audioList = allAudioListArray[moreBtn.tag]
        self.navigationController?.pushViewController(audioFileEditController!, animated: true)
    }
    
}

