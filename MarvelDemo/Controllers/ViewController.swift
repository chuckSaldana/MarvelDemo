//
//  ViewController.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.heroesArrived), name: NSNotification.Name(rawValue: "HeroesArrived"), object: nil)
        
        viewModel.traitCollection = traitCollection
        showLoading()
        viewModel.setupLayout(with: view.bounds.size, collectionView: collectionView)
    }
    
    @objc private func heroesArrived() {
        do {
            self.heroes = try DataLauncher.shared.coreDataHandler?.getAllManagedObjects(entityName: "Hero") ?? []
            self.enableUI()
        } catch let error {
            self.displayErrorMessage("An error occured \(error).")
        }
    }
    
    func enableUI() {
        DispatchQueue.main.async {
            self.hideLoading()
            self.viewModel.setupLayout(with: self.view.bounds.size, collectionView: self.collectionView)
            self.collectionView.reloadData()
        }
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
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "heroCellID"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HeroCollectionViewCell
        let hero: Hero = heroes[indexPath.row]
        cell.itemLabel.text = hero.name
        cell.itemImage.image = UIImage(named: "TestImage")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.isLastCellVisible(heroes: heroes, collectionView: collectionView) {
            showLoading()
            viewModel.requesMoreHeroes(heroes: heroes) { moreHeroes in
                self.heroes = moreHeroes
                self.enableUI()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HeroDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "HeroDetailViewController") as? HeroDetailViewController else {
            return
        }
        detailVC.hero = heroes[indexPath.row]
        self.navigationController?.show(detailVC, sender: nil)
    }
}

