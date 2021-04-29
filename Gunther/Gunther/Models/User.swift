//
//  User.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import UIKit

class User: NSObject, Codable {

    var id: String?
    var name: String?
    var artworks: [SavedArt] = []
    
}
