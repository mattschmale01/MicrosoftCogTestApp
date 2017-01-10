//
//  ViewController.swift
//  missingPersons
//
//  Created by Matthew Schmale on 1/3/17.
//  Copyright © 2017 SchmaleTests. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImg: UIImageView!
    
    var selectedPerson: Person?
    var hasSelectedImg: Bool = false
    
    let imagePicker = UIImagePickerController()
    
        let missingPeople = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person2.jpg"),
        Person(personImageUrl: "person3.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.png")
    ]
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            collectionView.delegate = self
            collectionView.dataSource = self
            imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(gesture:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        

        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        cell.configureCell(person: person)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! PersonCell
        
        cell.configureCell(person: selectedPerson!)
        cell.setSelected()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
            hasSelectedImg = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func showErrAlert(){
        let alert = UIAlertController.init(title: "Pick a person & Image", message: "Hurry up", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func checkMatch(sender: AnyObject){
        if selectedPerson == nil || !hasSelectedImg{
            showErrAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]?, err:Error?) in
                    if err == nil {
                        var faceId: String?
                        for face in faces! {
                            faceId = face.faceId
                            break
                        }
                        if faceId != nil {
                            FaceService.instance.client?.verify(withFirstFaceId: self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result: MPOVerifyResult?, err: Error?) in
                                
                                if err == nil {
                                    
                                    print(result?.confidence)
                                    print(result?.isIdentical)
                                    print(result.debugDescription)
                                } else {
                                    print(result.debugDescription)
                                }
                        })
                        }
                    }
                })
            }
        }
    }
}

