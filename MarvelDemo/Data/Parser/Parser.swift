//
//  Parser.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case contextNotFound
    case managedTypeNotFound
    case jsonObjectNotFound
    case dateWrongFormat
}

protocol Parser {
}

extension Parser {
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
