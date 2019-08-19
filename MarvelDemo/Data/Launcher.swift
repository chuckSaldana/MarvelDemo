//
//  Launcher.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation

protocol Launcher {
    var dataFetcher: HeroFetcher { get set }
    var parser: HeroParser { get set }
    var coreDataHandler: CoreDataHandler? { get set }
    
    func launchAppData()
}
