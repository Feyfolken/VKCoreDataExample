//
//  MainScreenInteractorOutput.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import Foundation

protocol MainScreenInteractorOutput: class {

    func didSaveNote(_ note: Note)
    func didUpdateNote(_ note: Note)
    func didObtainNotes(_ notes: [Note])
    func didDeleteNote()
}
