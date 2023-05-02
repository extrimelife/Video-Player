//
//  StorageManager.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 24.03.2023.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeTubePet")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func create(_ image: Data, _ title: String, _ isFavoriteStatus: Bool,
                _ description: String, _ subtitle: String, _ sources: String,
                completion: (Mask) -> Void) {
        let task = Mask(context: viewContext)
        task.image = image
        task.title = title
        task.isFavoriteStatus = isFavoriteStatus
        task.descriptio = description
        task.subtitle = subtitle
        task.sources = sources
        completion(task)
        saveContext()
    }
    
    // Get data from Storage
    func fetchData(completion: (Result<[Mask], Error>) -> Void) {
        let fetchRequest = Mask.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(_ task: Mask) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

