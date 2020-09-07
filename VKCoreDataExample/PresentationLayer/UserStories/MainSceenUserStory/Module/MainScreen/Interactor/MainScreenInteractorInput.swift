//
//  MainScreenInteractorInput.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import Foundation

protocol MainScreenInteractorInput {

    func obtainNotes()
    func saveNote(with text: String)
    func updateNote(_ note: Note)
    func deleteNote(_ note: Note)
}
