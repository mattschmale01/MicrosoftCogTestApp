//
//  FaceService.swift
//  missingPersons
//
//  Created by Matthew Schmale on 1/5/17.
//  Copyright © 2017 SchmaleTests. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "fccf7e4da7ac42cb9bb7e3984a373793")
    
    
}
