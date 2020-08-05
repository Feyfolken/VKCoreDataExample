//
//  ApplicationAssembly.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 04.08.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class ApplicationAssembly {
    
    //Use default dependency
    class var assembler: Assembler {
        let assemblyClasses = ApplicationAssemblyHelper().collectAssemblyClasses()
        return Assembler(assemblyClasses)
    }
    
    var assembler: Assembler
    
    //If you want use custom Assembler
    init(with assemblies: [Assembly]) {
        assembler = Assembler(assemblies)
    }
    
}

//Inject dependency in Main Storyboard
extension SwinjectStoryboard {

    @objc class func setup() {
        defaultContainer = ApplicationAssembly.assembler.resolver as! Container
    }

}



