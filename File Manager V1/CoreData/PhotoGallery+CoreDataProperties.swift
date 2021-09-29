//
//  PhotoGallery+CoreDataProperties.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 12/6/20.
//
//

import Foundation
import CoreData


extension PhotoGallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoGallery> {
        return NSFetchRequest<PhotoGallery>(entityName: "PhotoGallery")
    }

    @NSManaged public var folderName: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var urls: String?

}

extension PhotoGallery : Identifiable {

}
