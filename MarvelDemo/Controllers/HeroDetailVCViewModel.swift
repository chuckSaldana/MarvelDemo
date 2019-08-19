//
//  HeroDetailVCViewModel.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit

struct HeroDetailVCViewModel: HeroViewModel {
    func requestHeroRecommendations(hero: Hero, controller: UIViewController?, completion: @escaping ([Comic]) -> ()) {
        DataLauncher.shared.dataFetcher.fetchHeroRecommndations(endpoint: .heroStream, heroID: String(hero.hero_identifier)) { comicDictionary in
            do {
                let comicParser: ComicParser = ComicParser()
                let comicArray = try comicParser.getHeroRecommendationWith(dictionary: comicDictionary)
                completion(comicArray)
            } catch {
                print("error: \(error)")
                controller?.displayErrorMessage("Heroes couldn't arrive.")
            }
        }
    }
}
