//
//  CoreDataManager.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 29/04/2023.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "LifeProgress")
        if inMemory,
           let storeDescription = container.persistentStoreDescriptions.first {
            storeDescription.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Unable to configure Core Data Store: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        let viewContext = result.container.viewContext
        
        for number in 0..<10 {
            let newLifeGoalEntity = LifeGoalEntity(context: viewContext)
            newLifeGoalEntity.title = "Goal #\(number)"
            newLifeGoalEntity.details = "Very long and intersting details"
            newLifeGoalEntity.symbolName = "trophy"
            newLifeGoalEntity.createdAt = Date()
            newLifeGoalEntity.finishedAt = number % 2 == 0 ? Date() : nil
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("❌ Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
}
