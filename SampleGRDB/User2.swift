//
//  User2.swift
//  SampleGRDB
//
//  Created by SungYu on 2018. 8. 31..
//  Copyright © 2018년 Sung. All rights reserved.
//

import GRDB

struct User2: Decodable {
    var id: Int64?
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

extension User2: FetchableRecord {
    enum Columns: String, ColumnExpression {
        case id, name, email
    }
    
    init(row: Row) {
        id = row[Columns.id]
        name = row[Columns.name]
        email = row[Columns.email]
    }
}

extension User2: PersistableRecord {
    static var databaseTableName = "users"
    
    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.email] = email
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
