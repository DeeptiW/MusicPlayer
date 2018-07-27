//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 18/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit


protocol PlayerViewDelegate: class {
    func changePlayerBtn(_ isPlay: Bool?)
}

class PlayerView: UIView {
    weak var delegate: PlayerViewDelegate?
    @IBOutlet weak var playPauseBtn       : UIButton!

    
    class func instanceFromNib() -> UIView {
        //delegate?.changePlayerBtn(true)
        return UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    

    func changePlayerBtn(_ isPlay: Bool?){
        print(isPlay!)
    }
    
    
    
    @IBAction func previousBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex - 1
        playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        if currentSongIndex < 0 {
            currentSongIndex = allAudioListArray[currentCollectionTag].count - 1
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }else{
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
        NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: ["pause": "false"])
        NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: ["pause": "false"])


    }
    
    
    @IBAction func playpauseBtnAction(_ sender: Any) {
        if isPlay {
            player?.pause()
            isPlay = false
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: ["pause": "true"])
            NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: ["pause": "true"])

            
        }else{
            isPlay = true
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
            NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: ["pause": "false"])
            NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: ["pause": "false"])

        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex + 1
        playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        if currentSongIndex > allAudioListArray[currentCollectionTag].count - 1 {
            currentSongIndex = 0
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }else{
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
        NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: ["pause": "false"])
        NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: ["pause": "false"])
    }
    
    
    //play audio in queue
     func queueAudioPlayer()  {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)//
        currentSongIndex = currentSongIndex + 1
        if currentSongIndex > allAudioListArray[currentCollectionTag].count - 1 {
            currentSongIndex = 0
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }else{
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
        NotificationCenter.default.post(name: Notification.Name("ViewController"), object: nil, userInfo: ["pause": "false"])
        NotificationCenter.default.post(name: Notification.Name("AudioListViewController"), object: nil, userInfo: ["pause": "false"])
    }
    
}
