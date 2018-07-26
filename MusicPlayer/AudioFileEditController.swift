//
//  AudioFileEditController.swift
//  MusicPlayer
//
//  Created by Deepti Yashwant Walde on 10/07/18.
//  Copyright © 2018 Deepti Yashwant Walde. All rights reserved.
//

import UIKit
import CoreData



class EditAudioDetails: UITableViewCell {
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioDetails: UITextField!
    
}

class AudioFileEditController: UIViewController {

    @IBOutlet weak var thumbnailBtn: UIButton!
    @IBOutlet weak var audioFileEditTableView: UITableView!
    var audioFile : NSManagedObject! = nil
    var imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFileEditTableView.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround() 
        let image = UIImage(data: audioFile.value(forKey: "thumbnail") as! Data)
        thumbnailBtn.setImage(image, for: .normal)
        
        
        
    }

    
   
    
    
    //MARK:- Thumbnail Btn Action
    
    @IBAction func thumbnailBtnAction(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum;
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
}



//MARK:- Table View Datasource/ Delegate
extension AudioFileEditController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditDetails", for: indexPath) as! EditAudioDetails
        cell.audioDetails.tag = indexPath.row
        cell.audioDetails.delegate = self
        if indexPath.row == 0 {
            cell.audioTitle.text   = "Title"
            cell.audioDetails.text = audioFile.value(forKey: "title") as? String
        }else{
            cell.audioTitle.text   = "Author"
            cell.audioDetails.text = audioFile.value(forKey: "author") as? String
        }
        
        return cell
    }
    
    
    
    func editCoreData() {
        
        do {
            try managedContext?.save()
            
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
        
    }
    
}


//MARK:- Image Picker Delegate
extension AudioFileEditController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.thumbnailBtn.setImage(orginalImage, for: .normal)
                 let data = UIImagePNGRepresentation(orginalImage)
                self.audioFile.setValue(data, forKey: "thumbnail")
                self.editCoreData()
            }
            else { print ("error") }
        })
    }
}

//MARK:- Textfeild Delegate
extension AudioFileEditController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason){
        if textField.tag == 0{
            audioFile.setValue(textField.text, forKey: "title")
        }else{
            audioFile.setValue(textField.text, forKey: "author")
        }
        self.editCoreData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            audioFile.setValue(textField.text, forKey: "title")
        }else{
            audioFile.setValue(textField.text, forKey: "author")
        }
        self.editCoreData()
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
