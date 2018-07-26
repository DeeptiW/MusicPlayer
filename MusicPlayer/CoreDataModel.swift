//
//  CoreDataModel.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 05/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit
import CoreData


let appDelegate =
    UIApplication.shared.delegate as? AppDelegate
var managedContext : NSManagedObjectContext?
var fetchDetails: [NSManagedObject] = []
let entityName = "AudioFile"
var albumArray       = [Album]()
var fetchAuiodDetails: [NSManagedObject] = []


//MARK:- Store Details
func storeIncoreData(completion:@escaping (Bool)-> Void)  {
    
    let audioEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!
    for album in albumArray{
       // let details = details as! AudioResult
        /*let localAudio = NSManagedObject(entity: audioEntity, insertInto: managedContext)
        localAudio.setValue(album.author, forKey: "author")
        localAudio.setValue(album.title, forKey: "title")
        localAudio.setValue(album.isPlay, forKey: "isPlay")
        localAudio.setValue(album.url, forKey: "url")
        localAudio.setValue(album.thumbnail, forKey: "thumbnail")
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }*/
        
        
        // Create Entity
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)
        
        // Initialize Record
        let audioList = AudioFile(entity: entity!, insertInto: managedContext)
        audioList.author    = album.author
        audioList.title     = album.title
        audioList.isPlay    = album.isPlay!
        audioList.url       = album.url
        audioList.thumbnail = album.thumbnail! as NSData
        audioList.audioName = album.audioName!
        
        
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    completion(true)
    
    
}

//MARK:- Fetch Details
func fetchFromCoreData(completion:@escaping (Bool)-> Void)  {
    
    //2
    let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: entityName)
    
    //3
    do {
        fetchDetails = []
        fetchDetails = (try managedContext?.fetch(fetchRequest))!
        completion(true)
        
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
}




//MARK:- Remove Details
func removeDetailsFromCoreData(completion:@escaping (Bool)-> Void)  {
    let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityName))
    do {
        try managedContext?.execute(DelAllReqVar)
        completion(true)
    }
    catch {
        print(error)
    }
    
}

func removeParticularDataFromCoreData(completion:@escaping (Bool)-> Void){
 
}


//MARK:- retrieve
func createPlaylist(audioFile : NSManagedObject, playlistName : String){
    
    
    
    
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioPlaylist")
    let predicate = NSPredicate(format: "playlistName == %@", playlistName)
    request.predicate = predicate
    request.fetchLimit = 1
    
    do{
        let count = try managedContext?.count(for: request)
        if(count == 0){
            // no matching object
            let audioPlaylistEntity = NSEntityDescription.entity(forEntityName: "AudioPlaylist", in: managedContext!)!
            let playlistAudio = NSManagedObject(entity: audioPlaylistEntity, insertInto: managedContext)
            playlistAudio.setValue(playlistName, forKey: "playlistName")
            playlistAudio.setValue(audioFile, forKey: "audioUrl")
            
            
        }
        else{
            // at least one matching object exists
            
            if let fetchResults = try managedContext?.fetch(request) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue(audioFile, forKey: "audioUrl")
                    
                   // context.save(nil)
                }
            }
        }
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
    
    
    
    
    
    
    
    
    
   
}


//MARK:- Fetch Details
func fetchPlaylist(entityName: String, completion:@escaping (Bool)-> Void)  {
    let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: entityName)
    do {
        fetchAuiodDetails = (try managedContext?.fetch(fetchRequest))!
        print("fetch Audio Details \(fetchAuiodDetails)")
        completion(true)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
}

//Mark : Insert using data model
var managedObjectContext: NSManagedObjectContext!
func storeInCoreData(audioFile : NSManagedObject, playlistName : String)  {
    managedObjectContext = appDelegate?.persistentContainer.viewContext
    // Create Entity
    let entity = NSEntityDescription.entity(forEntityName: "AudioPlaylist", in: managedObjectContext)
    
    // Initialize Record
    let playlistAudio = NSManagedObject(entity: entity!, insertInto: managedContext) as! AudioPlaylist
    playlistAudio.playlistName = playlistName
    // audiolist object chahiye create krna padega?
    //playlistAudio.addToAudioUrl()
    
    //playlistAudio.
    
    do {
        try managedObjectContext?.save()
    } catch let error as NSError {
        print("Could not save. \(error)")
    }
    
}

func editContent(isPlay : Bool, audioName: String, name: AudioFile){
    if let managedObjectContext = appDelegate?.persistentContainer.viewContext {
        //            let place : Places = Places()
        //            place.isFavourite = cell.isFavouriteLabel.text
        do{
            try managedObjectContext.save()
        } catch let error as NSError{
            print(error)
        }
    }
}


func temp(audioFile : NSManagedObject, playlistName : String)  {
    
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioPlaylist")
    let predicate = NSPredicate(format: "playlistName == %@", playlistName)
    request.predicate = predicate
    request.fetchLimit = 1
    
    do{
        let count = try managedContext?.count(for: request)
        if(count == 0){
            // no matching object
            // Create Entity
            let entity = NSEntityDescription.entity(forEntityName: "AudioPlaylist", in: managedContext!)
            
            // Initialize Record
            let playlistAudio = AudioPlaylist(entity: entity!, insertInto: managedContext)
            playlistAudio.playlistName = playlistName
         //   playlistAudio.audioUrl = audioFile as? AudioList
           // playlistAudio.audio  = audioFile as NSObject
              playlistAudio.addToAudioFile(audioFile as! AudioFile)
        }
        else{
            // at least one matching object exists
            
            if let fetchResults = try managedContext?.fetch(request) as? [AudioPlaylist] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    //managedObject.setValue(audioFile, forKey: "audioUrl")
                    //managedObject.audioUrl = audioFile as? AudioList
                    // context.save(nil)
                    
                    //managedObject.audio = audioFile as NSObject
                    managedObject.addToAudioFile(audioFile as! AudioFile)
                 //   managedObject.audioFile = audioFile
                }
            }
        }
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
    
    
    
}


extension NSManagedObject {
    func addObject(value: NSManagedObject, forKey: String) {
        let items = self.mutableSetValue(forKey: forKey);
        items.add(value)
    }
}
