//
//  AudioFile+CoreDataProperties.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 16/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//
//

import Foundation
import CoreData


extension AudioFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioFile> {
        return NSFetchRequest<AudioFile>(entityName: "AudioFile")
    }

    @NSManaged public var author: String?
    @NSManaged public var isPlay: Bool
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var audioName: String?
    @NSManaged public var audioPlaylist: NSSet?

}

// MARK: Generated accessors for audioPlaylist
extension AudioFile {

    @objc(addAudioPlaylistObject:)
    @NSManaged public func addToAudioPlaylist(_ value: AudioPlaylist)

    @objc(removeAudioPlaylistObject:)
    @NSManaged public func removeFromAudioPlaylist(_ value: AudioPlaylist)

    @objc(addAudioPlaylist:)
    @NSManaged public func addToAudioPlaylist(_ values: NSSet)

    @objc(removeAudioPlaylist:)
    @NSManaged public func removeFromAudioPlaylist(_ values: NSSet)

}
