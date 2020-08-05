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
    
}

extension MainScreenPresenter: MainScreenModuleInput {
    
}

extension MainScreenPresenter: MainScreenViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }
}

extension MainScreenPresenter: MainScreenInteractorOutput {
    
}
