//
//  AddToPlaylistViewController.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 11/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit
import CoreData

class CreateNewPlaylistCell: UITableViewCell {
    
}

class AddToPlayListCell: UITableViewCell {
    
    @IBOutlet weak var playlistName: UILabel!
}


class AddToPlaylistViewController: UIViewController {

    @IBOutlet weak var playlistTable: UITableView!
    var playlistArray = NSMutableArray()
    var audioFile : NSManagedObject! = nil
    var audioUrl : URL! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTable.tableFooterView = UIView()
        
        fetchPlaylist(entityName: "AudioPlaylist") { (true) in
            self.playlistTable.reloadData()
        }
        
        
//        let tempDetails = fetchAuiodDetails[0] as! AudioPlaylist
//        print(tempDetails.audioUrl)
//
        
        let file = audioFile as! AudioFile
        audioUrl =  file.url
        
        
        
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

//MARK:- Tableview Delegate/Datasource
extension AddToPlaylistViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return fetchAuiodDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateNewPlaylistCell", for: indexPath) as! CreateNewPlaylistCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToPlayListCell", for: indexPath) as! AddToPlayListCell
            let playList = fetchAuiodDetails[indexPath.row]
            cell.playlistName.text = playList.value(forKey: "playlistName") as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            createPlaylistAction()
        default:
           // print("Add to playlist")
            let playlist = fetchAuiodDetails[indexPath.row] as! AudioPlaylist
            saveAudioFile(playlistName: playlist.playlistName!)
        }
    }
    
    func createPlaylistAction() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create New Playlist", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
           
            
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            self.playlistArray.add(textField?.text)
            //createPlaylist(audioFile: self.audioFile, playlistName: textField!.text!)
           // storeInCoreData(audioFile: self.audioFile, playlistName: textField!.text!)
            
            //temp(audioFile: self.audioFile, playlistName: textField!.text!)
            
//            let audioURl = self.audioFile as! AudioFile
//            let audioArray = NSMutableArray()
//            audioArray.add(audioURl.url)
            
//            saveAudioFile(url: <#T##URL#>, playlistName: <#T##String#>)
            
            self.saveAudioFile(playlistName: textField!.text!)
            
            self.playlistTable.reloadData()
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
  
   
    
    func saveAudioFile(playlistName : String)  {
        temp(audioFile: audioFile, playlistName: playlistName)
    }
    
}
