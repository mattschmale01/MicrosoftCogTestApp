//
//  PersonCell.swift
//  missingPersons
//
//  Created by Matthew Schmale on 1/3/17.
//  Copyright © 2017 SchmaleTests. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    
    var person: Person!
    
    func configureCell(person: Person){
        self.person = person 
        if let url = NSURL(string: "\(baseURL)\(person.personImageUrl!)") {
            downloadImage(url: url)
        }
        
    }
    
    func setSelected(){
        personImg.layer.borderWidth = 2.0
        personImg.layer.borderColor = UIColor.yellow.cgColor
        
         self.person.downloadFaceId()
        
    }
    
    func downloadImage(url: NSURL){
        getDataFromURL(url: url) { (data, response, error) in
           DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else { return }
                self.personImg.image = UIImage(data: data as Data)
                self.person.personImage = self.personImg.image
            
        }
    }
}
    
    func getDataFromURL(url: NSURL, completion: @escaping (( _ data: NSData?, _ response: URLResponse?, _ error: NSError?)->Void)){
        
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
        } .resume()
    }
}

