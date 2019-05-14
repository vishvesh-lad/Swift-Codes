//
//  CoreDataService.swift
//  MyDB
//
//  Created by Vicky Prajapati.
//

import Foundation

enum CoreDataContextEnum {
    case MainQueueContext,
    PrivateContext
}

class CoreDataService: NSObject {
    
    //MARK:- Variables
    static let sharedInstance = CoreDataService()
    private override init() {}
    
    //ManagedObject Context for CoreData
    lazy var mainQueueContext: NSManagedObjectContext? = {
        let parentContext = self.masterContext
        
        if parentContext == nil {
            return nil
        }
        
        var mainQueueContext =
            NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainQueueContext.parent = parentContext
        mainQueueContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return mainQueueContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let parentContext = self.mainQueueContext
        
        var privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateQueueContext.parent = parentContext
        privateQueueContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return privateQueueContext
    }()
    
    func getContext(coreDataContextEnum: CoreDataContextEnum = .MainQueueContext) -> NSManagedObjectContext{
        switch coreDataContextEnum {
        case .MainQueueContext:
            return mainQueueContext!
        case .PrivateContext:
            return self.privateManagedObjectContext
        }
    }
    
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MyDB", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MyDB.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        print(url)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    private lazy var masterContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        var masterContext =
            NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = coordinator
        masterContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return masterContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        CoreDataService.sharedInstance.getContext(coreDataContextEnum: .PrivateContext).perform {
            if CoreDataService.sharedInstance.getContext(coreDataContextEnum: .PrivateContext).hasChanges{
                do {
                    //Saves in private context
                    try CoreDataService.sharedInstance.getContext(coreDataContextEnum: .PrivateContext).save()
                } catch {
                    //fatalError("Failure to save context: \(error)")
                    print("Failure to save private context: \(error)")
                }
            }
        }
            
        CoreDataService.sharedInstance.getContext().performAndWait({
            if CoreDataService.sharedInstance.getContext().hasChanges{
                do {
                    //print("SAVE CONTEXT: save changes in Main Context")
                    // Saves the changes from the child to the main context to be applied properly
                    try CoreDataService.sharedInstance.getContext().save()
                } catch {
                    // fatalError("Failure to save context: \(error)")
                    print("Failure to save main queue context: \(error)")
                }
            }else{
                //print("SAVE CONTEXT: No changes in Main Context")
            }
        })
            
        CoreDataService.sharedInstance.masterContext?.performAndWait({
            if CoreDataService.sharedInstance.masterContext?.hasChanges ?? false{
                do {
                    //print("SAVE CONTEXT: save changes in Master Context")
                    // Saves the changes from the child to the main context to be applied properly
                    try CoreDataService.sharedInstance.masterContext?.save()
                } catch {
                    // fatalError("Failure to save context: \(error)")
                    print("Failure to save master context: \(error)")
                }
            }else{
                //print("SAVE CONTEXT: No changes in Master Context")
            }
        })
    }
    
    //MARK:- Private Methods
    //Clear all data from Core data
    public func clearCoreDataStore() {
        let entities = managedObjectModel.entities
        for entity in entities {
            if let entityName = entity.name{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try self.getContext().execute(deleteReqest)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //Remove all objects from entity
    func removeObjectsFor(entityName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let objects = try self.getContext().fetch(fetchRequest)
            for object in objects {
                print("Deleting \(entityName) object")
                self.getContext().delete(object as! NSManagedObject)
                try self.getContext().save()
            }
        } catch  {
            print("Failed to remove \(entityName) object: \(error.localizedDescription)")
        }
    }
    
    //Get auto incremented id for entity
    func getIncrementedId(idKeyName: String, entityName: String, context: NSManagedObjectContext) -> Int64 {
        var incrementedId: Int64 = 1
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: idKeyName, ascending: false)
        fetchRequest.sortDescriptors = [idDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let list = try context.fetch(fetchRequest)
            if list.count == 1 {
                incrementedId = ((list[0] as AnyObject).value(forKey: idKeyName) as! Int64) + 1
            }
            return incrementedId
        } catch let error as NSError {
            print("LOG: getIncrementedId \(error.userInfo)")
            return incrementedId
        }
    }
    
    //Check & return is matching record with predicate exist
    func getRecordIfExistIn(predicate: NSPredicate, entityName: String, context: NSManagedObjectContext) -> (isRecordExist: Bool, Records: [Any]?)? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                return (true, result)
            }
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        
        return (false, nil)
    }
}


