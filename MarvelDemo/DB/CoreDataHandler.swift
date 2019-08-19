//
//  CoreDataHandler.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum CoreDataHandlerError: Error {
    case appDelegateNotFound
    case entityNotFound
    case failedSaving
}

class CoreDataHandler {
    var context: NSManagedObjectContext?
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
        }
    }
    
    func saveData() throws {
        do {
            try context?.save()
        } catch {
            throw CoreDataHandlerError.failedSaving
        }
    }
    
    func getAllManagedObjects<T>(entityName: String) throws -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context?.fetch(request)
            return result as? [T] ?? []
        } catch let error {
            throw error
        }
    }
    
}

