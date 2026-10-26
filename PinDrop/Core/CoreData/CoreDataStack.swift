//
//  CoreDataTask.swift
//  PinDrop
//
//  Created by Ivan on 17.10.2026.
//

import Foundation
import CoreData

class CoreDataStack: CoreDataStackProtocol {
    
    private let container: NSPersistentContainer
    
    var viewContet: NSManagedObjectContext {
        
        container.viewContext
    }
    
    init(inMemory: Bool = false) {
        
        let model = Self.buildModel()
        container = NSPersistentContainer(name: "PinDropModel", managedObjectModel: model)
        
        if inMemory {
            let storeDescription = NSPersistentStoreDescription()
            storeDescription.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [storeDescription]
            
        }
        
        container.loadPersistentStores { [weak self] _, error in
            
            if let error = error {
                
                print("CoreData error: \(error)")
                return
            }
            
            self?.configureViewContext()
            print("CoreData is ready")
            
        }
    }
    
    private func configureViewContext() {
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
    }
    
    func saveFavourite(_ place: Place, completion: @escaping (Result<Void, Error>) -> Void) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let entity = FavouritePlaceEntity(context: context)
            entity.populate(from: place)
            
            do {
                if context.hasChanges {
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
            }
            
        }
    }
    
    func fetchFavourite(completion: @escaping (Result<[Place], Error>) -> Void) {
        
        let context = viewContet
        
        context.perform {
            let request: NSFetchRequest<FavouritePlaceEntity> = FavouritePlaceEntity.fetchRequest()
            
            do {
                
                let results = try context.fetch(request)
                let places = results.map { $0.toDomain() }
                
                DispatchQueue.main.async {
                    completion(.success(places))

                }
                                
            } catch  {
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
            }
            
        }
        
    }
    
    
    private static func buildModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = FavouritePlaceEntity.entityName
        entity.managedObjectClassName = String(describing: FavouritePlaceEntity.self)
        
        let idAttr = makeAttribute(name: "id", type: .stringAttributeType, isOptional: false)
        let nameAttr = makeAttribute(name: "name", type: .stringAttributeType, isOptional: false)
        let categoryAttr = makeAttribute(name: "category", type: .stringAttributeType, isOptional: false, defaultValue: "Unknown")
        let latAttr = makeAttribute(name: "latitude", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0)
        let lonAttr = makeAttribute(name: "longitude", type: .doubleAttributeType, isOptional: false, defaultValue: 0.0)
        let addressAttr = makeAttribute(name: "address", type: .stringAttributeType, isOptional: true)
        
        entity.properties = [idAttr, nameAttr, categoryAttr, latAttr, lonAttr, addressAttr]
        
        entity.uniquenessConstraints = [["id"]]
        
        model.entities = [entity]
        
        return model
    }
    
    private static func makeAttribute(name: String, type: NSAttributeType, isOptional: Bool, defaultValue: Any? = nil) -> NSAttributeDescription {
        
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = isOptional
        attribute.defaultValue = defaultValue
        return attribute
        
    }
    
}
