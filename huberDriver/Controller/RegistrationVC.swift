//
//  RegistrationVC.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 20/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationVC : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerViewData : [String] = [ "economic", "comfort", "vip" ]
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var carNameTF: UITextField!
    @IBOutlet weak var classPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       classPicker.delegate = self
 //       classPicker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTF.text, let pass = passwordTF.text, let name = nameTF.text, let car = carNameTF.text {
            Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                if result != nil {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "currentUser"), object: nil, userInfo: [
                        "email" : email
                    ])
                    self.saveInfo(name: name, email: email, car: car, classC: self.pickerViewData[self.classPicker.selectedRow(inComponent: 0)])
                }
            }
        }
    }
    
    
    private func saveInfo(name : String, email : String, car : String, classC : String) {
        Firestore.firestore().collection("drivers").document(email).setData([
            "email" : email,
            "name" : name,
            "car" : car,
            "class" : classC,
            "isDriver" : true
        ])
    }
    
}
