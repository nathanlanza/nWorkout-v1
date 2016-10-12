import Foundation
import CoreData

extension Routine {

    @NSManaged public var name: String?
    @NSManaged public var lifts: NSOrderedSet?
    @NSManaged public var note: String?
    @NSManaged public var order: Int16

}

// MARK: Generated accessors for lifts
extension Routine {

    @objc(insertObject:inLiftsAtIndex:)
    @NSManaged public func insertIntoLifts(_ value: RoutineLift, at idx: Int)

    @objc(removeObjectFromLiftsAtIndex:)
    @NSManaged public func removeFromLifts(at idx: Int)

    @objc(insertLifts:atIndexes:)
    @NSManaged public func insertIntoLifts(_ values: [RoutineLift], at indexes: NSIndexSet)

    @objc(removeLiftsAtIndexes:)
    @NSManaged public func removeFromLifts(at indexes: NSIndexSet)

    @objc(replaceObjectInLiftsAtIndex:withObject:)
    @NSManaged public func replaceLifts(at idx: Int, with value: RoutineLift)

    @objc(replaceLiftsAtIndexes:withLifts:)
    @NSManaged public func replaceLifts(at indexes: NSIndexSet, with values: [RoutineLift])

    @objc(addLiftsObject:)
    @NSManaged public func addToLifts(_ value: RoutineLift)

    @objc(removeLiftsObject:)
    @NSManaged public func removeFromLifts(_ value: RoutineLift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ values: NSOrderedSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ values: NSOrderedSet)

}
