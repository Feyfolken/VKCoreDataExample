//
//  MainScreenAssemblyContainer.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class MainScreenAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		container.register(MainScreenInteractor.self) { (r, presenter: MainScreenPresenter) in
			let interactor = MainScreenInteractor()
			interactor.output = presenter
            interactor.dataStorageService = r.resolve(DataStorageService.self)
            
			return interactor
		}
		
		container.register(MainScreenRouter.self) { (r, viewController: MainScreenViewController) in
			let router = MainScreenRouter()
			router.transitionHandler = viewController
			
			return router
		}
		
		container.register(MainScreenPresenter.self) { (r, viewController: MainScreenViewController) in
			let presenter = MainScreenPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(MainScreenInteractor.self, argument: presenter)
			presenter.router = r.resolve(MainScreenRouter.self, argument: viewController)
			
			return presenter
		}
        
		container.storyboardInitCompleted(MainScreenViewController.self) { r, viewController in
			viewController.output = r.resolve(MainScreenPresenter.self, argument: viewController)
		}
	}
}
