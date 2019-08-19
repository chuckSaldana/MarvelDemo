//
//  HeroParser.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum ParsingError: Error {
    case contextNotFound
    case managedTypeNotFound
    case jsonObjectNotFound
    case dateWrongFormat
}

typealias DictionaryLocator = (object: NSManagedObject, dictionary: [String: Any])
typealias ArrayLocator = (object: NSManagedObject, array: [[String: Any]])

struct HeroParser {
    // Find each object in the json and iterate throughout collections to pupulate the curriculum object
    @discardableResult
    func getHeroWith(dictionary: [String: Any]) throws -> Set<Hero> {
        guard let context = DataLauncher.shared.coreDataHandler?.context else {
            throw ParsingError.contextNotFound
        }
        
        let dataLocator: [String: Any] = try collecionInDictionaryWith(jsonName: "data",
                                                                                   enclosingDictionary: dictionary)
        let resultsLocator: [[String: Any]] = try collecionInDictionaryWith(jsonName: "results",
                                                                                enclosingDictionary: dataLocator)
        var heroes: Set<Hero> = Set()
        for result in resultsLocator {
            guard let heroEntity = NSEntityDescription.entity(forEntityName: "Hero", in: context) else {
                throw ParsingError.managedTypeNotFound
            }
            
            let newHero = NSManagedObject(entity: heroEntity, insertInto: context)
            newHero.setValue(result["name"], forKey: "name")
            newHero.setValue(result["description"], forKey: "hero_description")
            
            let thumbnailLocator: [String: Any] = try collecionInDictionaryWith(jsonName: "thumbnail",
                                                                                  enclosingDictionary: result)
            let path = thumbnailLocator["path"] as? String ?? String()
            let photoExtension = thumbnailLocator["extension"] as? String ?? String()
            let imageURL = path + "." + photoExtension
            newHero.setValue(imageURL, forKey: "photo_url")
           
            guard let hero = newHero as? Hero else {
                throw ParsingError.managedTypeNotFound
            }
            heroes.insert(hero)
        }
        
        return heroes
    }
    
    // Find the corresponding json object
    func collecionInDictionaryWith<T>(jsonName: String, enclosingDictionary: [String: Any]) throws -> T where T: Collection {
        guard let collection = enclosingDictionary[jsonName] as? T else {
            throw ParsingError.jsonObjectNotFound
        }
        return collection
    }
    
    // Convert date
    func dateWith(string: Any) throws -> Date? {
        guard let dateStr = string as? String else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        
        guard let date = dateFormatter.date(from: dateStr) else {
            throw ParsingError.dateWrongFormat
        }
        
        return date
    }
}
