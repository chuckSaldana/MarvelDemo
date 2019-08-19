//
//  ViewControllerViewModel.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit

struct ViewControllerViewModel {
    var traitCollection: UITraitCollection?
    weak var controller: ViewController?
    
    func setupLayout(with containerSize: CGSize, collectionView: UICollectionView) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let minItemWidth: CGFloat
            
            if UIDevice.current.orientation.isLandscape {
                minItemWidth = containerSize.width / 5
            } else {
                minItemWidth = containerSize.width / 3
            }
            
            let numberOfCell = containerSize.width / minItemWidth
            let width = floor((numberOfCell / floor(numberOfCell)) * minItemWidth)
            let height = ceil(width * (4.0 / 3.0))
            
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize(width: width, height: height)
            flowLayout.sectionInset = .zero
            
        } else {
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0)
            
            if traitCollection?.horizontalSizeClass == .regular {
                let minItemWidth: CGFloat = 300
                let numberOfCell = containerSize.width / minItemWidth
                let width = floor((numberOfCell / floor(numberOfCell)) * minItemWidth)
                flowLayout.itemSize = CGSize(width: width, height: 400)
            } else {
                flowLayout.itemSize = CGSize(width: containerSize.width, height: 400)
            }
        }
        
        collectionView.reloadData()
    }
    
    func requesMoreHeroes(heroes: [Hero], completion: @escaping ([Hero]) -> ()) {
        DataLauncher.shared.dataFetcher.fetchHeroStream(endpoint: .heroStream, offset: heroes.count) { heroDictionary in
            do {
                let heroesSet = try DataLauncher.shared.parser.getHeroWith(dictionary: heroDictionary)
                completion(heroes + Array(heroesSet))
            } catch {
                print("error: \(error)")
                self.controller?.displayErrorMessage("Heroes couldn't arrive.")
            }
        }
    }
    
    func isLastCellVisible(heroes: [Hero], collectionView: UICollectionView) -> Bool {
        
        if heroes.isEmpty {
            return true
        }
        
        let lastIndexPath = NSIndexPath(item: heroes.count - 1, section: 0)
        var cellFrame = collectionView.layoutAttributesForItem(at: lastIndexPath as IndexPath)!.frame
        
        cellFrame.size.height = cellFrame.size.height
        
        var cellRect = collectionView.convert(cellFrame, to: collectionView.superview)
        
        cellRect.origin.y = cellRect.origin.y - cellFrame.size.height - 100
        // substract 100 to make the "visible" area of a cell bigger
        
        var visibleRect = CGRect(
            x: collectionView.bounds.origin.x,
            y: collectionView.bounds.origin.y,
            width: collectionView.bounds.size.width,
            height: collectionView.bounds.size.height - collectionView.contentInset.bottom
        )
        
        visibleRect = collectionView.convert(visibleRect, to: collectionView.superview)
        
        if visibleRect.contains(cellRect) {
            return true
        }
        
        return false
    }
}
