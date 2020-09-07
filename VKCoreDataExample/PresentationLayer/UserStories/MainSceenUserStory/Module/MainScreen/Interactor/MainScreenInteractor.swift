//
//  MainScreenInteractor.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

class MainScreenInteractor {

    weak var output: MainScreenInteractorOutput!
    var dataStorageService: DataStorageService!
}

extension MainScreenInteractor: MainScreenInteractorInput {
    
    func obtainNotes() {
        dataStorageService.obtainNotes { (notesArray) in
            if let rawNotesArray = notesArray {
                self.output.didObtainNotes(rawNotesArray)
            }
        }
    }
    
    func saveNote(with text: String) {
        dataStorageService.saveNote(with: text) { (savedNote) in
            if let rawSavedNote = savedNote {
                self.output.didSaveNote(rawSavedNote)
            }
        }
    }
    
    func updateNote(_ note: Note) {
        dataStorageService.updateNote(note) { (updatedNote) in
            if let rawUpdatedNote = updatedNote {
                self.output.didUpdateNote(rawUpdatedNote)
            }
        }
    }
    
    func deleteNote(_ note: Note) {
        dataStorageService.deleteNote(note) {
            self.output.didDeleteNote()
        }
    }
}
