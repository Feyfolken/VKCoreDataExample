//
//  MainScreenViewOutput.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//
import UIKit

protocol MainScreenViewOutput {

    func viewIsReady()
    func didTapAddNoteButton()
    func didTapDeleteNoteButton(note: Note)
    func didSelectCell(at indexPath: IndexPath, item: Note)
}
