//
//  PlaylistViewController.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 16/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    @IBOutlet weak var playlistTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Playlist"
        playlistTable.tableFooterView = UIView()
        fetchPlaylist(entityName: "AudioPlaylist") { (true) in
            self.playlistTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension PlaylistViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchAuiodDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let playList = fetchAuiodDetails[indexPath.row]
        cell.textLabel?.text = playList.value(forKey: "playlistName") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let audioFileEditController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioListViewController") as? AudioListViewController
        audioFileEditController?.currentListTag = indexPath.row
        audioFileEditController?.audioList = allAudioListArray[indexPath.row]
        self.navigationController?.pushViewController(audioFileEditController!, animated: true)*/
    }
    
}
