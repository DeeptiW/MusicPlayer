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
        if currentSongIndex < 0 {
            currentSongIndex = allAudioListArray[currentCollectionTag].count - 1
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }else{
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
    }
    
    
    @IBAction func playpauseBtnAction(_ sender: Any) {
        if isPlay {
            player?.pause()
            isPlay = false
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        //    albumArray[currentSongIndex].isPlay = false
        }else{
            //   player?.play()
            isPlay = true
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            //albumArray[currentSongIndex].isPlay = true
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        currentSongIndex = currentSongIndex + 1
        if currentSongIndex > allAudioListArray[currentCollectionTag].count - 1 {
            currentSongIndex = 0
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }else{
            SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        }
    }
    
    
    //play audio in queue
     func queueAudioPlayer()  {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)//NSNotification.Name.AVPlayerItemDidPlayToEndTime
        albumArray[currentSongIndex].isPlay = false
        currentSongIndex = currentSongIndex + 1
        
        /*if currentSongIndex > audioFileArray.count - 1 {
         albumArray[0].isPlay = true
         //    playUsingAVPlayer(url: audioFileArray[0])
         currentSongIndex = 0
         }else{
         albumArray[currentSongIndex].isPlay = true
         //  playUsingAVPlayer(url: audioFileArray[currentSongIndex])
         }*/
        //    audioCollectionView.reloadData()
        
        
    }
    
}
