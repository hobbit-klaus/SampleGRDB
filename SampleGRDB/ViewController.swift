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
    
    class User: Record {
        var id: Int64?
        var name: String
        var email: String
        
        init(id: Int64? = nil, name: String, email: String) {
            self.id = id
            self.name = name
            self.email = email
            
            super.init()
        }
        
        required init(row: Row) {
            id = row[Columns.id]
            name = row[Columns.name]
            email = row[Columns.email]
            
            super.init(row: row)
        }
        
        override func encode(to container: inout PersistenceContainer) {
            container[Columns.id] = id
            container[Columns.name] = name
            container[Columns.email] = email
        }
        
        override func didInsert(with rowID: Int64, for column: String?) {
            id = rowID
        }
        
        /// The table name
        override class var databaseTableName: String {
            return "users"
        }
        
        enum Columns: String, ColumnExpression {
            case id, name, email
        }
    }
    
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
                _ = try User.deleteAll(db)
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
                let user1 = User(name: "User1", email: "a@a.com")
                let user2 = User(name: "User2", email: "c@b.com")
                let user3 = User(name: "User3", email: "c@c.com")
                
                try user1.insert(db)
                try user2.insert(db)
                try user3.insert(db)
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func listUsers(_ sender: Any) {
        do {
            try dbQueue.read { db in
                let users = try User.fetchAll(db)
                for user in users {
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
                let user = try User.fetchOne(db, key: ["email": "a@a.com"])
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
                _ = try User.deleteOne(db, key: ["email": "d@d.com"])
            }
        } catch {
            print(error)
        }
    }
}

