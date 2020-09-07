//
//  ServicesAssembly.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 01.09.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import Swinject

class ServicesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(DataStorageService.self) { r in
            let dataStorageServiceImplementation = DataStorageServiceImplementation()
            
            return dataStorageServiceImplementation
        }
    }
}

