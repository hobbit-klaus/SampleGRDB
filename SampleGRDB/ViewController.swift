//
//  ViewController.swift
//  SampleGRDB
//
//  Created by SungYu on 2018. 8. 28..
//  Copyright © 2018년 Sung. All rights reserved.
//

import UIKit
import GRDB

class ViewController: UIViewController {
    
    var dbQueue: DatabaseQueue!
    
    let usersTable = "users"
    let id = "id"
    let name = "name"
    let email = "email"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite")
            
            dbQueue = try DatabaseQueue(path: fileUrl.path)
            
            try dbQueue.write { db in
                _ = try User2.deleteAll(db)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func createTable(_ sender: Any) {
        print("CREATE TAPPED")
        do {
            try dbQueue.write { db in
                try db.create(table: usersTable) { table in
                    table.autoIncrementedPrimaryKey(id).primaryKey()
                    table.column(name)
                    table.column(email)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func insertUser(_ sender: Any) {
        do {
            try dbQueue.write { db in
                let user1 = User2(name: "User1", email: "a@a.com")
                
                try user1.insert(db)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func listUsers(_ sender: Any) {
        do {
            try dbQueue.read { db in
                let users = try User2.fetchAll(db)
                for user in users {
                    print(user.id ?? 0)
                    print(user.name)
                    print(user.email)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func updateUser(_ sender: Any) {
        do {
            try dbQueue.write { db in
//                for user in try User.fetchAll(db) where user.name == "User1" {
//                    user.email = "d@d.com"
//                    try user.update(db)
//                }
                
                // Such records can also delete according to primary key or any unique index:
                var user = try User2.fetchOne(db, key: 1)
                user?.email = "d@d.com"
                try user?.update(db)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        do {
            try dbQueue.write { db in
                _ = try User2.deleteOne(db, key: 1)
            }
        } catch {
            print(error)
        }
    }
}
