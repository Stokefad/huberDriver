//
//  Driver.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 20/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import Foundation

class Driver {
    
    var name : String = ""
    var car : String = ""
    var carClass : CarClasses = .notSelected
    var isDriver = true
    var onWork : Bool = false
    var email : String = ""
    
}

enum CarClasses {
    case notSelected
    case econom
    case comfort
    case vip
}
