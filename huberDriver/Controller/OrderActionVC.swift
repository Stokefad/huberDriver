//
//  OrderActionVC.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 21/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrderActionVC : UIViewController {
    
    var currentDriver : Driver?
    var currentUser : Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func endOrder() {
        
        let db = Firestore.firestore()
        
        if let client = currentUser {
            db.collection("users").document(client.email).collection("rides").addDocument(data: [
                "active" : false
                ])
        }
        if let driver = currentDriver {
            db.collection("drivers").document(driver.email).collection("rides").addDocument(data: [
                "active" : false
                ])
        }
        }
    
}
