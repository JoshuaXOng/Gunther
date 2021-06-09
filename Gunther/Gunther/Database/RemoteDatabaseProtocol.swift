//
//  RemoteDatabaseProtocol.swift
//  Gunther
//
//  Created by user184453 on 5/23/21.
//

import Foundation
import UIKit

/*
 * Inherits from DatabaseProtocol.
 * This is a more specific database interface -- it is to be used for
 * databases that are 'remote', i.e. not within the device.
 * This interface mainly includes callbacks, which are quite necessary
 * for remote databases and not so much for something like CoreData.
 */
protocol RemoteDatabaseProtocol: DatabaseProtocol {
    
    func fetchArtImageFromArt(art: SavedArt, completionHandler: @escaping (UIImage?) -> Void) throws
    
    func fetchAllArtImagesFromCategory(category: Category, completionHandler: @escaping ([UIImage?]) -> Void)
    func fetchCategoriesThumbnails(completionHandler: @escaping ([UIImage?]) -> Void)

    func fetchAllArtImagesFromUser(user: User, completionHandler: @escaping ([UIImage?]) -> Void)
    
}
