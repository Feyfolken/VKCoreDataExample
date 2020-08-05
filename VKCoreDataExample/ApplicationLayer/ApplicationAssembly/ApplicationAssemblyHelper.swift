//
//  ApplicationAssemblyHelper.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 04.08.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//
import Foundation
import Swinject

class ApplicationAssemblyHelper {

    func collectAssemblyClasses() -> Array<Assembly> {
        var allClassesCount: UInt32 = 0
        let allClasses = objc_copyClassList(&allClassesCount)!

        return UnsafeBufferPointer(start: allClasses, count: Int(allClassesCount))
            .filter{$0 is Assembly.Type}
            .map {$0.alloc() as! Assembly}
    }
}
