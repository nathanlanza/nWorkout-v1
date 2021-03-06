import Foundation
import CoreData

@objc(RoutineSet)
public class RoutineSet: nSet {

    override var settableWeight: Int {
        set { weight = Int16(newValue) }
        get { return Int(weight) }
    }
    override var settableReps: Int {
        set { reps = Int16(newValue) }
        get { return Int(reps) }
    }
}

extension RoutineSet: ManagedObjectType {
    public static var entityName: String {
        return "RoutineSet"
    }
    
    func toSet() -> WorkoutSet {
        let lSet = WorkoutSet(context: managedObjectContext!)
        lSet.targetWeight = weight
        lSet.targetReps = reps
        return lSet
    }
}
