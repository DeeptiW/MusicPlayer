//
//  CustomCollectionCell.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 09/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit

class CustomCollectionCell: NSObject {

}

// GridView
class CustomCell : UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var playBtn: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    
}

//List View
class ListViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumAuthor: UILabel!
    @IBOutlet weak var playBtn: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
}
