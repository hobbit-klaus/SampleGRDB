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
                    table.column(email).unique()
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func insertUser(_ sender: Any) {
        do {
            try dbQueue.write { db in
                try db.execute("""
                    INSERT INTO users (name, email) VALUES (?, ?);
                """, arguments: ["User1", "a@a.com"])
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func listUsers(_ sender: Any) {
        do {
            try dbQueue.read { db in
//                let rows = try Row.fetchCursor(db, "SELECT * FROM users")
//                while let row = try rows.next() {
//                    let name: String = row["name"]
//                    let email: String = row["email"]
//
//                    print(name)
//                    print(email)
//                }
                
                let rows = try Row.fetchAll(db, "SELECT * FROM users")
                for row in rows {
                    let name: String = row["name"]
                    let email: String = row["email"]
                    
                    print(name)
                    print(email)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func updateUser(_ sender: Any) {
    }
    
    @IBAction func deleteUser(_ sender: Any) {
    }
}

