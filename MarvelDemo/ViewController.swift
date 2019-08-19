//
//  ViewController.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    var heroes: [Hero] = []
    
    func showLoading() {
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    func requesMoreHeroes(lastKnownIndex: Int) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        requesMoreHeroes(lastKnownIndex: 0)
        setupLayout(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLayout(with: size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayout(with: view.bounds.size)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "heroCellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HeroCollectionViewCell
        cell.itemLabel.text = "Test Name"
        cell.itemImage.image = UIImage(named: "TestImage")
        
        return cell
    }
    
    private func setupLayout(with containerSize: CGSize) {
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
            
            if traitCollection.horizontalSizeClass == .regular {
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
    
    /*
     -(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     int scrollViewWidth = scrollView.contentSize.width;
     
     CGPoint offset = scrollView.contentOffset;
     if(offset.x < scrollViewWidth /4){
     offset.x += scrollViewWidth / 2;
     [scrollView setContentOffset:offset];
     } else if(offset.x > scrollViewWidth /4 *3){
     offset.x -= scrollViewWidth / 2;
     [scrollView setContentOffset:offset];
     }
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == heroes.count {
            showLoading()
            requesMoreHeroes(lastKnownIndex: indexPath.row)
        }
    }
}

