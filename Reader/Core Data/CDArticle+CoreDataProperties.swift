//
//  CDArticle+CoreDataProperties.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//
//

public import Foundation
public import CoreData


public typealias CDArticleCoreDataPropertiesSet = NSSet

extension CDArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArticle> {
        return NSFetchRequest<CDArticle>(entityName: "CDArticle")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var descText: String?
    @NSManaged public var url: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var isBookmarked: Bool

}

extension CDArticle : Identifiable {

}
