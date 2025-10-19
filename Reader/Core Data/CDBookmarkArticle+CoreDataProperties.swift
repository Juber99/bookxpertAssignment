//
//  CDBookmarkArticle+CoreDataProperties.swift
//  Reader
//
//  Created by juber99 on 19/10/25.
//
//

public import Foundation
public import CoreData


public typealias CDBookmarkArticleCoreDataPropertiesSet = NSSet

extension CDBookmarkArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBookmarkArticle> {
        return NSFetchRequest<CDBookmarkArticle>(entityName: "CDBookmarkArticle")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var url: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var content: String?

}

extension CDBookmarkArticle : Identifiable {

}
