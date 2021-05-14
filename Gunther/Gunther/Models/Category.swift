//
//  Category.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import UIKit

class Category: NSObject, Codable {
    
    var id: String?
    var name: String?
    var source: String?
    var artworks: [SavedArt] = []
    
}
