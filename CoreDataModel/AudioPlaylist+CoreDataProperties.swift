//
//  AudioPlaylist+CoreDataProperties.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 16/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//
//

import Foundation
import CoreData


extension AudioPlaylist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioPlaylist> {
        return NSFetchRequest<AudioPlaylist>(entityName: "AudioPlaylist")
    }

    @NSManaged public var audio: NSObject?
    @NSManaged public var playlistName: String?
    @NSManaged public var audioFile: NSSet?

}

// MARK: Generated accessors for audioFile
extension AudioPlaylist {

    @objc(addAudioFileObject:)
    @NSManaged public func addToAudioFile(_ value: AudioFile)

    @objc(removeAudioFileObject:)
    @NSManaged public func removeFromAudioFile(_ value: AudioFile)

    @objc(addAudioFile:)
    @NSManaged public func addToAudioFile(_ values: NSSet)

    @objc(removeAudioFile:)
    @NSManaged public func removeFromAudioFile(_ values: NSSet)

}
