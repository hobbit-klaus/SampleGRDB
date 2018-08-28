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
    }
    
    @IBAction func insertUser(_ sender: Any) {
    }
    
    @IBAction func listUsers(_ sender: Any) {
    }
    
    @IBAction func updateUser(_ sender: Any) {
    }
    
    @IBAction func deleteUser(_ sender: Any) {
    }
}

