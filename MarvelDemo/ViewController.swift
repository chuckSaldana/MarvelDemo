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
    var viewModel = ViewControllerViewModel()
    
    func showLoading() {
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    func requesMoreHeroes(lastKnownIndex: Int) {
        hideLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.traitCollection = traitCollection
        showLoading()
        requesMoreHeroes(lastKnownIndex: 0)
        viewModel.setupLayout(with: view.bounds.size, collectionView: collectionView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewModel.setupLayout(with: size, collectionView: collectionView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewModel.setupLayout(with: view.bounds.size, collectionView: collectionView)
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
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == heroes.count {
            showLoading()
            requesMoreHeroes(lastKnownIndex: indexPath.row)
        }
    }
}

