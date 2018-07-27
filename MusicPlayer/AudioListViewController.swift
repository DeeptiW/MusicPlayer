//
//  AudioListViewController.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 10/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit


class AudioListViewController: UIViewController {
    var isGrid           = false
    var rightBarButton  : UIBarButtonItem!
    var audioList       : [AudioFile]!
    var currentListTag  : Int!
    
    @IBOutlet weak var audioListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfAudioListViewController(notification:)), name: Notification.Name("AudioListViewController"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioListCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        window.viewWithTag(100)?.isHidden = false
    }
    
    @objc func methodOfAudioListViewController(notification: Notification){
        
        guard let pause = notification.userInfo?["pause"] as? String else { return }
        
        if  pause == "true" {
            for audio in allAudioListArray[currentCollectionTag]{
                audio.isPlay = false
            }
        }
        
        audioListCollectionView.reloadData()
    }
    
    func createRightBarItem() {
        let customBtn = UIButton(type: UIButtonType.custom)
        customBtn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        customBtn.addTarget(self, action: #selector(rightBarBtnaAction(_:)), for: .touchUpInside)
        rightBarButton = UIBarButtonItem(customView: customBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }


    
    @objc func rightBarBtnaAction(_ sender: Any) {
        if isGrid{
            setupView(grid: false)
        }else{
            setupView(grid: true)
        }
    }
    
    func setupView(grid: Bool)  {
        let layout = UICollectionViewFlowLayout()
        if isGrid {
            //layout.scrollDirection = .vertical
            rightBarButton.image = #imageLiteral(resourceName: "grid")
        }else{
            //layout.scrollDirection = .horizontal
            rightBarButton.image = #imageLiteral(resourceName: "list")
        }
        isGrid = grid
        audioListCollectionView.collectionViewLayout = layout
        audioListCollectionView.reloadData()
    }
    
}





//MARK:- Collection View Delegate/ DataSource/ FlowLayout
extension AudioListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let audioDetails = audioList[indexPath.row]
        if isGrid{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
            cell.thumbnail.image =  UIImage(data: audioDetails.thumbnail! as Data)!
            if audioDetails.isPlay  {
                cell.playBtn.image = #imageLiteral(resourceName: "pause")
            }else{
                cell.playBtn.image = #imageLiteral(resourceName: "play")
            }
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listView", for: indexPath) as! ListViewCell
            cell.moreBtn.tag = indexPath.row
            cell.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            cell.thumbnail.image   =  UIImage(data: audioDetails.thumbnail! as Data)!
            cell.albumTitle.text   =  audioDetails.title
            cell.albumAuthor.text  =  audioDetails.author
          
            if audioDetails.isPlay  {
                cell.playBtn.image = #imageLiteral(resourceName: "pause")
            }else{
                cell.playBtn.image = #imageLiteral(resourceName: "play")
            }
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if currentCollectionTag != currentListTag{
            SingletonMusicPlayer.shared.resetCollection(collectionTag: currentCollectionTag)
        }
        
        collectionView.tag = currentListTag
        
        
        
        if isPlay && currentSongIndex == indexPath.row{
            isPlay = false
            player?.pause()
            SingletonMusicPlayer.shared.customView?.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            let audioDetails = allAudioListArray[collectionView.tag][indexPath.row]
            audioDetails.isPlay = false
            audioListCollectionView.reloadData()
            return
        }
        
        if isPlay && currentSongIndex != indexPath.row{
            SingletonMusicPlayer.shared.customView?.playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
        if !isPlay{
            SingletonMusicPlayer.shared.customView?.playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            isPlay = true
        }
        
        
        currentSongIndex     = indexPath.row
        currentCollectionTag = collectionView.tag
        SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: currentSongIndex)
        audioListCollectionView.reloadData()
    }
    
    //Set collection view grid
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        if !isGrid {
            return CGSize(width: width, height: 75)
        }else {
            return CGSize(width: (width - 15)/2, height: (width - 15)/2)
        }
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
    @objc func editAction(_ sender: Any)  {
        let audioFileEditController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AudioFileEditController") as? AudioFileEditController
        let editBtn = sender as! UIButton
        audioFileEditController?.audioFile = audioList[editBtn.tag]
        self.navigationController?.pushViewController(audioFileEditController!, animated: true)
    }
    
    @objc func moreBtnAction(_ sender: Any) {
        window.viewWithTag(100)?.isHidden = true
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let playAction = UIAlertAction(title: "Play Now", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Play song")
            self.playAudioAction(sender)
        })
        let playlistAction = UIAlertAction(title: "Add To Playlist", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addToPlayListAction(sender)
        })
        let editPlaylistAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.editAction(sender)
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            window.viewWithTag(100)?.isHidden = false
        })
        
        // 4
        optionMenu.addAction(playAction)
        optionMenu.addAction(playlistAction)
        optionMenu.addAction(editPlaylistAction)
        optionMenu.addAction(cancelAction)

        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func addToPlayListAction(_ sender : Any) {
        let addToPlaylistViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToPlaylistViewController") as! AddToPlaylistViewController
        let addBtn = sender as! UIButton
        addToPlaylistViewController.audioFile = audioList[addBtn.tag]
        window.viewWithTag(100)?.isHidden = false
        self.present(addToPlaylistViewController, animated: true, completion: nil)
    }
    
    func playAudioAction(_ sender : Any)  {
        let playBtn = sender as! UIButton
       // let audioFile = audioList[playBtn.tag]
      //  playUsingAVPlayer(url: audioFile.url)
        SingletonMusicPlayer.shared.playSong(collectionTag: currentCollectionTag, indexRow: playBtn.tag)
        window.viewWithTag(100)?.isHidden = false
        audioListCollectionView.reloadData()
    }
    
   
}
