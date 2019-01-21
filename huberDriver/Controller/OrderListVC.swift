//
//  OrderListVC.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 21/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class OrderListVC : UIViewController {
    
    @IBOutlet weak var orderTV: UITableView!
    @IBOutlet weak var acceptButton: UIButton!
    
    var clientList : [Client] = [Client]()
    
    var currentDriver : Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveOrders()
        
        acceptButton.isHidden = true
        
    }
    
    private func driveTV() {
        let dBag = DisposeBag()
        BehaviorRelay(value: clientList).asDriver().drive(orderTV.rx.items(cellIdentifier: "orderCell", cellType: OrderCell.self)) { _, data, cell in
            cell.nameLabel.text = data.email
        }
            .disposed(by: dBag)
    }
    
    private func selectTC() {
        let dBag = DisposeBag()
        orderTV.rx.itemSelected.subscribe(onNext : { [weak self] indexPath in
            self!.acceptButton.isHidden = false
            
        })
            .disposed(by: dBag)
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        if let indexPath = orderTV.indexPathForSelectedRow {
            getOrder(client: clientList[indexPath.row])
        }
    }
    
    private func getOrder(client : Client) {
        let db = Firestore.firestore()
        
        db.collection("users").document(client.email).setData([
            "inSearch" : false
        ])
        
        if let driver = currentDriver {
            db.collection("users").document(client.email).collection("rides").addDocument(data: [
                "driver" : driver.name,
                "cost" : 200,
                "car" : driver.car,
                "active" : true
            ])
        }
        
        db.collection("drivers").document(client.email).collection("rides").addDocument(data: [
            "user" : client.name,
            "cost" : 200,
            "active" : true
        ])
    }
    
    private func retrieveOrders() {
        Firestore.firestore().collection("users").filter(using: NSPredicate(format: "inSearch == true")).getDocuments { [weak self](snapshot, error) in
            if let documents = snapshot?.documents {
                for item in documents {
                    let client = Client()
                    
                    client.email = (item["email"] as? String)!
                    self!.clientList.append(client)
                    
                    self!.driveTV()
                }
            }
        }
    }
    
}
