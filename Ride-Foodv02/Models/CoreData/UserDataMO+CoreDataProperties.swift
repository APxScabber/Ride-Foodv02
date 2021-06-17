//
//  UserDataMO+CoreDataProperties.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 10.06.2021.
//
//

import Foundation
import CoreData


extension UserDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataMO> {
        return NSFetchRequest<UserDataMO>(entityName: "UserDataMO")
    }

    @NSManaged public var create_at: NSNumber?
    @NSManaged public var delete_at: NSNumber?
    @NSManaged public var email: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var update_at: NSNumber?
    @NSManaged public var settings: UserSettingsMO?
}

