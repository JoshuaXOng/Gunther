//
//  RemoteDatabaseProtocol.swift
//  Gunther
//
//  Created by user184453 on 5/23/21.
//

import Foundation
import UIKit

protocol RemoteDatabaseProtocol: DatabaseProtocol {
    
    func fetchArtImageFromArt(art: SavedArt, completionHandler: @escaping (UIImage?) -> Void) throws
    
    func fetchAllArtImagesFromCategory(category: Category, completionHandler: @escaping ([UIImage?]) -> Void)
    func fetchCategoriesThumbnails(completionHandler: @escaping ([UIImage?]) -> Void)

    func fetchAllArtImagesFromUser(user: User, completionHandler: @escaping ([UIImage?]) -> Void)
    
}
