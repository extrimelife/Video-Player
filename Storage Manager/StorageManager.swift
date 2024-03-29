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
    
    // MARK: - Save FavoriteMovie To CoreData
    
    func save(video: Video, image: Data) {
        guard let url = URL(string: video.sources) else { return }
        let task = Mask(context: viewContext)
        task.id = url.lastPathComponent
        task.image = image
        task.title = video.title
        task.descriptio = video.description
        task.sources = video.sources
        saveContext()
    }
    
    func saveMask(video: Mask, image: Data) {
        guard let url = URL(string: video.sources ?? "") else { return }
        let task = Mask(context: viewContext)
        task.id = url.lastPathComponent
        task.image = image
        task.title = video.title
        task.descriptio = video.description
        task.sources = video.sources
        saveContext()
    }
    
    // MARK: - Remove FavoriteMovie from CoreData
    
    func removeFavoriteMovie(id: String) {
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Mask")
        requestDel.returnsObjectsAsFaults = false
        do {
            let data = try viewContext.fetch(requestDel)
            let mask = data as! [Mask]
            guard let videoToBeRemoved = mask.first(where: { $0.id == id }) else { return }
            viewContext.delete(videoToBeRemoved)
        } catch {
            print("Failed")
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed delete")
        }
    }
    
    // MARK: - Search if the movie is already in coredata
    
    func checkMovieInCoreDataFor(id: String) -> Bool {
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Mask")
        requestDel.returnsObjectsAsFaults = false
        let data = try? viewContext.fetch(requestDel)
        let video = data as? [Mask]
        
        return video?.contains(where: { $0.id == id }) ?? false
    }
    
    // MARK: - Get All Data From Storage
    
    func fetchData(completion: (Result<[Mask], Error>) -> Void) {
        let fetchRequest = Mask.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: Delete All Data From CoreData
    
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

