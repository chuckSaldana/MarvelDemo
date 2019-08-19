//
//  HeroViewModel.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit

protocol HeroViewModel {
}

extension HeroViewModel {
    func requesMoreHeroes(heroes: [Hero], controller: UIViewController?, completion: @escaping ([Hero]) -> ()) {
        DataLauncher.shared.dataFetcher.fetchHeroStream(endpoint: .heroStream, offset: heroes.count) { heroDictionary in
            do {
                let heroesSet = try DataLauncher.shared.heroParser.getHeroWith(dictionary: heroDictionary)
                completion(heroes + Array(heroesSet))
            } catch {
                print("error: \(error)")
                controller?.displayErrorMessage("Heroes couldn't arrive.")
            }
        }
    }
}
