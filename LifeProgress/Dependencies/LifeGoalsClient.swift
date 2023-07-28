//
//  LifeGoalsClient.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 16/04/2023.
//

import CoreData
import Combine
import Dependencies

struct LifeGoalsClient {
    // A closure that asynchronously returns life goals.
    var fetchLifeGoals: () async -> [LifeGoal]
    
    // A closure that asynchronously creates a life goal.
    var createLifeGoal: (LifeGoal) async -> Void
    
    // A closure that asynchronously updates a life goal.
    var updateLifeGoal: (LifeGoal) async -> Void
    
    // A closure that asynchronously deletes a life goal.
    var deleteLifeGoal: (LifeGoal) async -> Void
}

// MARK: Dependency Key

extension LifeGoalsClient: DependencyKey {
    
    /// A live value of `LifeGoalsClient`  for managing life goals.
    static let liveValue = LifeGoalsClient(
        fetchLifeGoals: {
            let viewContext = CoreDataManager.shared.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()
            
            // Add a sort descriptor to sort by creationDate
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                let lifeGoals = fetchedEntities.map { entity in
                    return LifeGoal(
                        id: entity.id!,
                        title: entity.title!,
                        finishedAt: entity.finishedAt,
                        symbolName: entity.symbolName!,
                        details: entity.details!
                    )
                }
                return lifeGoals
            } catch {
                print("❌ Couldn't fetch life goals")
                return []
            }
        },
        createLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.shared.container.viewContext
            let entity = LifeGoalEntity(context: viewContext)
            
            entity.id = UUID()
            entity.createdAt = Date()
            entity.title = lifeGoal.title
            entity.details = lifeGoal.details
            entity.symbolName = lifeGoal.symbolName
            entity.finishedAt = lifeGoal.finishedAt
            entity.type = 1
                        
            do {
                viewContext.insert(entity)
                try viewContext.save()
            } catch {
                print("❌ Couldn't create life goal")
            }
        },
        updateLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.shared.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", lifeGoal.id as CVarArg)

            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                if let entity = fetchedEntities.first {
                    entity.title = lifeGoal.title
                    entity.details = lifeGoal.details
                    entity.symbolName = lifeGoal.symbolName
                    entity.finishedAt = lifeGoal.finishedAt
                    
                    try viewContext.save()
                } else {
                    print("❌ Couldn't find life goal with id: \(lifeGoal.id)")
                }
            } catch {
                print("❌ Couldn't update life goal")
            }
        },
        deleteLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.shared.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", lifeGoal.id as CVarArg)

            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                if let entity = fetchedEntities.first {
                    viewContext.delete(entity)
                    try viewContext.save()
                } else {
                    print("❌ Couldn't find life goal with id: \(lifeGoal.id)")
                }
            } catch {
                print("❌ Couldn't delete life goal")
            }
        }
    )
}

// MARK: Test Dependency Key

extension LifeGoalsClient: TestDependencyKey {
    
    /// A preview instance of `LifeGoalsClient` with mock data for SwiftUI previews and testing purposes.
    static let previewValue = Self(
        fetchLifeGoals: {
            let viewContext = CoreDataManager.preview.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()

            // Add a sort descriptor to sort by creationDate
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]

            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                let lifeGoals = fetchedEntities.map { entity in
                    return LifeGoal(
                        id: entity.id!,
                        title: entity.title!,
                        finishedAt: entity.finishedAt,
                        symbolName: entity.symbolName!,
                        details: entity.details!
                    )
                }
                return lifeGoals
            } catch {
                print("❌ Couldn't fetch life goals")
                return []
            }
        },
        createLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.preview.container.viewContext
            let entity = LifeGoalEntity(context: viewContext)

            entity.id = UUID()
            entity.createdAt = Date()
            entity.title = lifeGoal.title
            entity.details = lifeGoal.details
            entity.symbolName = lifeGoal.symbolName
            entity.finishedAt = lifeGoal.finishedAt
            entity.type = 1

            do {
                viewContext.insert(entity)
                try viewContext.save()
            } catch {
                print("❌ Couldn't create life goal")
            }
        },
        updateLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.preview.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", lifeGoal.id as CVarArg)

            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                if let entity = fetchedEntities.first {
                    entity.title = lifeGoal.title
                    entity.details = lifeGoal.details
                    entity.symbolName = lifeGoal.symbolName
                    entity.finishedAt = lifeGoal.finishedAt

                    try viewContext.save()
                } else {
                    print("❌ Couldn't find life goal with id: \(lifeGoal.id)")
                }
            } catch {
                print("❌ Couldn't update life goal")
            }
        },
        deleteLifeGoal: { lifeGoal in
            let viewContext = CoreDataManager.preview.container.viewContext
            let fetchRequest: NSFetchRequest<LifeGoalEntity> = LifeGoalEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", lifeGoal.id as CVarArg)

            do {
                let fetchedEntities = try viewContext.fetch(fetchRequest)
                if let entity = fetchedEntities.first {
                    viewContext.delete(entity)
                    try viewContext.save()
                } else {
                    print("❌ Couldn't find life goal with id: \(lifeGoal.id)")
                }
            } catch {
                print("❌ Couldn't delete life goal")
            }
        }
    )
    
    /// A test instance of `LifeGoalsClient` with mock data for unit testing purposes.
    static let testValue = Self(
        fetchLifeGoals: { [] },
        createLifeGoal: { _ in },
        updateLifeGoal: { _ in },
        deleteLifeGoal: { _ in }
    )
}

// MARK: Dependency Values

extension DependencyValues {
    var lifeGoalsClient: LifeGoalsClient {
        get { self[LifeGoalsClient.self] }
        set { self[LifeGoalsClient.self] = newValue }
    }
}
