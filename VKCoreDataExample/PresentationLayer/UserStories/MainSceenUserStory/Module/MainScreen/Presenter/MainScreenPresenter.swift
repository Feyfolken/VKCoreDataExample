//
//  MainScreenPresenter.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import UIKit

class MainScreenPresenter {
    
    weak var view: MainScreenViewInput!
    var interactor: MainScreenInteractorInput!
    var router: MainScreenRouterInput!
    
    private func createAlertController(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let newNote = alertController.textFields?.first {
                print("Did tap save option")
                //TODO: - CoreData service request
            }
        }
        
        alertController.addTextField { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        view.presentAlertController(alertController, animated: true)
    }
}

extension MainScreenPresenter: MainScreenModuleInput {
    
}

extension MainScreenPresenter: MainScreenViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func didTapAddNoteButton() {
        createAlertController(with: "New note", and: "Type the text of new note")
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        createAlertController(with: "Update note", and: "Type the new text")
    }
}

extension MainScreenPresenter: MainScreenInteractorOutput {
    
}
