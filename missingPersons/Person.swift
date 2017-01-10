//
//  Person.swift
//  missingPersons
//
//  Created by Matthew Schmale on 1/5/17.
//  Copyright © 2017 SchmaleTests. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var faceId: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String){
        self.personImageUrl = personImageUrl
    }
    
    
    func downloadFaceId(){
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]?, err: Error?) in
                if err == nil {
                    var faceId: String?
                    for face in faces!{
                        faceId = face.faceId
                        print("Face Id: \(faceId)")
                        break
                    }
                    self.faceId = faceId
                }
            })
        }
    }
}
