//
//  NSManagedObjectContext+Extensions.swift
//  Tracker
//

import CoreData


// MARK: - NSManagedObjectContext
extension NSManagedObjectContext {
    func saveContext() {        
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
