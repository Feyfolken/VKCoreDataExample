//
//  MainScreenPresenter.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import UIKit

enum NoteOperationType {
    case create, update
}

class MainScreenPresenter {
    
    weak var view: MainScreenViewInput!
    var interactor: MainScreenInteractorInput!
    var router: MainScreenRouterInput!
    
    private var selectedNoteIndex = 0
    private var currentNote: Note!
    
    private func createAlertController(with title: String, and message: String, operationType: NoteOperationType) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField = alertController.textFields?.first {
                self.performOperation(of: operationType, forNoteWithText: textField.text)
            }
        }
        
        alertController.addTextField { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        view.presentAlertController(alertController, animated: true)
    }
    
    private func performOperation(of type: NoteOperationType, forNoteWithText text: String?) {
        switch type {
        case .create:
            interactor.saveNote(with: text ?? "")
            
        case .update:
            currentNote.text = text
            interactor.updateNote(currentNote)
        }
    }
}

extension MainScreenPresenter: MainScreenModuleInput {
    
}

extension MainScreenPresenter: MainScreenViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        
        interactor.obtainNotes()
    }
    
    func didTapAddNoteButton() {
        createAlertController(with: "New note", and: "Type the text of new note", operationType: .create)
    }
    
    func didTapDeleteNoteButton(note: Note) {
        interactor.deleteNote(note)
    }
    
    func didSelectCell(at indexPath: IndexPath, item: Note) {
        selectedNoteIndex = indexPath.row
        currentNote = item
        createAlertController(with: "Update note", and: "Type the new text", operationType: .update)
    }
}

//MARK: - MainScreenInteractorOutput
extension MainScreenPresenter: MainScreenInteractorOutput {
    
    func didObtainNotes(_ notes: [Note]) {
        view.updateNotesAfterObtaining(notes)
    }
    
    func didSaveNote(_ note: Note) {
        view.updateNotesAfterAdding(note)
    }
    
    func didUpdateNote(_ note: Note) {
        view.updateNotesAfterUpdating(with: note, for: selectedNoteIndex)
    }
    
    func didDeleteNote() {
        interactor.obtainNotes()
    }
}
