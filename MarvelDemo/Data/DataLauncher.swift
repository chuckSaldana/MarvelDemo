//
//  DataLauncher.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation

struct DataLauncher: Launcher {
    static let shared = DataLauncher()
    
    var dataFetcher: HeroFetcher = HeroFetcher()
    var parser: HeroParser = HeroParser()
    var coreDataHandler: CoreDataHandler?
    
    init() {
        coreDataHandler = CoreDataHandler()
    }
    
    func launchAppData() {
        dataFetcher.fetchHeroStream(endpoint: .heroStream, offset: 0) { heroDictionary in
            DispatchQueue.main.async {
                do {
                    try self.parser.getHeroWith(dictionary: heroDictionary)
                    try self.coreDataHandler?.saveData()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeroesArrived"), object: nil, userInfo: nil)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }
    }
}
