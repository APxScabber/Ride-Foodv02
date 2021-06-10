//
//  UserSettingsMO+CoreDataProperties.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 10.06.2021.
//
//

import Foundation
import CoreData


extension UserSettingsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSettingsMO> {
        return NSFetchRequest<UserSettingsMO>(entityName: "UserSettingsMO")
    }

    @NSManaged public var do_not_call: Bool
    @NSManaged public var language: String?
    @NSManaged public var notification_discount: Bool
    @NSManaged public var update_mobile_network: Bool
    @NSManaged public var userData: UserDataMO?

}
