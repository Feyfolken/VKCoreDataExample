//
//  DataStorageService.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 01.09.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import CoreData

protocol DataStorageService {
    
    func obtainNotes(completion: @escaping (_ notes: [Note]?) -> ())
    func saveNote(with text: String, completion: @escaping (_ note: Note?) -> ())
    func updateNote(_ note: Note, completion: @escaping (_ note: Note?) -> ())
    func deleteNote(_ note: Note, completion: @escaping () -> ())
}
