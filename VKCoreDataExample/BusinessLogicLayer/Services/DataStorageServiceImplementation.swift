//
//  DataStorageServiceImplementation.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 01.09.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import CoreData

class DataStorageServiceImplementation {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VKCoreDataExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}

// MARK: - Core Data Saving support
extension DataStorageServiceImplementation: DataStorageService {
    
    func obtainNotes(completion: @escaping ([Note]?) -> ()) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            let notesArray = try context.fetch(fetchRequest)
            completion(notesArray)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            
            completion(nil)
        }
    }
    
    func saveNote(with text: String, completion: @escaping (_ note: Note?) -> ()) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        
        let noteObject = Note(entity: entity, insertInto: context)
        noteObject.text = text
        
        do {
            try context.save()
            completion(noteObject)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            
            completion(nil)
        }
    }
    
    func updateNote(_ note: Note, completion: @escaping (Note?) -> ()) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(note)
                
            } catch {
                completion(nil)

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteNote(_ note: Note, completion: @escaping () -> ()) {
        let context = persistentContainer.viewContext

        context.delete(note)
        
        do {
            try context.save()
            completion()
            
        } catch {

            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
