//
//  User.swift
//  SampleGRDB
//
//  Created by SungYu on 2018. 8. 31..
//  Copyright © 2018년 Sung. All rights reserved.
//

import GRDB

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
