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
                flowLayout.itemSize = CGSize(width: width, height: 91)
            } else {
                flowLayout.itemSize = CGSize(width: containerSize.width, height: 91)
            }
        }
        
        collectionView.reloadData()
    }
}
