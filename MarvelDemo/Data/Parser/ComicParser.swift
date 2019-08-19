//
//  ComicParser.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import CoreData

struct ComicParser: Parser {
    func getHeroRecommendationWith(dictionary: [String: Any]) throws -> [Comic] {
        let dataLocator: [String: Any] = try collecionInDictionaryWith(jsonName: "data",
                                                                       enclosingDictionary: dictionary)
        let resultsLocator: [[String: Any]] = try collecionInDictionaryWith(jsonName: "results",
                                                                            enclosingDictionary: dataLocator)
        var comics: [Comic] = []
        for result in resultsLocator {
            guard let thumbnailLocator = result["thumbnail"] as? [String: Any] else {
                throw ParsingError.jsonObjectNotFound
            }
            let path = thumbnailLocator["path"] as? String ?? String()
            let photoExtension = thumbnailLocator["extension"] as? String ?? String()
            let imageURL = path + "." + photoExtension
            let newCommic = Comic(imageUrl: imageURL)
            
            comics.append(newCommic)
        }
        
        return comics
    }
}
