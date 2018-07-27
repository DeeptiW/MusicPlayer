//
//  SingletonMusicPlayer.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 24/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit
import AVFoundation

var player               : AVPlayer?
var docPath              : String?
var currentSongIndex     : Int = 0
var currentCollectionTag : Int = 0
var isPlay                     = false
var allAudioListArray          = [[AudioFile]]()
let window = UIApplication.shared.keyWindow!

class SingletonMusicPlayer: NSObject {

    static let shared : SingletonMusicPlayer = SingletonMusicPlayer()
    var baseURL: String?
    var customView : PlayerView?
    
    
    //MARK:- Handle audio played in queue
    func playUsingAVPlayer(audioName: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            let url = URL(string: "\(docPath!)\(audioName)")
            player = AVPlayer(url: url!)
            player?.play()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
                SingletonMusicPlayer.shared.customView?.queueAudioPlayer()
            }
        } catch {
            print(error)
        }
    }
    
    func playerView(){
        SingletonMusicPlayer.shared.customView = (PlayerView.instanceFromNib() as! PlayerView)
        SingletonMusicPlayer.shared.customView?.frame = CGRect(x: 0, y: window.frame.height - (49+50), width: window.frame.width, height: 50)
        SingletonMusicPlayer.shared.customView?.tag = 100
        window.addSubview(SingletonMusicPlayer.shared.customView!)
        
    }
    
    
   
    
    
}

extension SingletonMusicPlayer {
    func getFilesFromDD(completion:@escaping (Bool)-> Void)  {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            getAlbumArrayList(audioFileArray: fileURLs, completion: completion)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    
    func getAlbumArrayList(audioFileArray : [URL], completion:@escaping (Bool)-> Void)  {
        for url in audioFileArray {
            albumArray.append(getAllDetails(url: url))
        }
        
        completion(true)
        
    }
    
    
    func getAllDetails(url : URL) -> Album {
        
        let urlString : String = "\(url)"
        var audioName = ""
        if let range = urlString.range(of: "Documents/") {
            let tempName = urlString[range.upperBound...]
            audioName = "\(tempName)"
        }
        
        var albumFile = Album.init()
        let asset = AVAsset(url: url) as AVAsset
        if asset.commonMetadata.count == 0 {
            
            albumFile.author    = "unknown"
            let data = UIImagePNGRepresentation(#imageLiteral(resourceName: "audio-play-icon"))
            albumFile.thumbnail = data
            albumFile.title     = "unknown"
            albumFile.url       = url
            albumFile.isPlay    = false
            albumFile.audioName = audioName
            
            return albumFile
        }else{
            for metaDataItems in asset.commonMetadata {
                
                if metaDataItems.commonKey!.rawValue == "artwork" {
                    let imageData = metaDataItems.value as! NSData
                    albumFile.thumbnail = imageData as Data
                }
                
                if metaDataItems.commonKey!.rawValue == "author"{
                    albumFile.author = metaDataItems.value as? String
                }
                
                if metaDataItems.commonKey!.rawValue == "title"{
                    albumFile.title = metaDataItems.value as? String
                }
                
                albumFile.url    = url
                albumFile.isPlay = false
                albumFile.audioName = audioName
                
            }
            return albumFile
        }
        
    }
}

//MARK:- Play Current player
extension SingletonMusicPlayer {
    func playSong(collectionTag : Int, indexRow: Int)  {
        let audioDetails = allAudioListArray[collectionTag][indexRow]
        SingletonMusicPlayer.shared.playUsingAVPlayer(audioName: audioDetails.audioName!)
        for audio in allAudioListArray[collectionTag]{
            audio.isPlay = false
        }
        audioDetails.isPlay = true
        NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: nil)
        NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: nil)
    }
    
    func resetCollection(collectionTag : Int)  {
        for audio in allAudioListArray[collectionTag]{
            audio.isPlay = false
        }
    }
    
}
