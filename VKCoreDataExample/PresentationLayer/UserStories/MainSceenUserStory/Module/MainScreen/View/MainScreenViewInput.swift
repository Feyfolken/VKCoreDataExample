//
//  MainScreenViewInput.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import UIKit

protocol MainScreenViewInput: class {

    func setupInitialState()
    func presentAlertController(_ alertController: UIAlertController, animated: Bool)
    func updateNotesAfterObtaining(_ notes: [Note])
    func updateNotesAfterAdding(_ note: Note)
    func updateNotesAfterUpdating(with note: Note, for index: Int)
}
