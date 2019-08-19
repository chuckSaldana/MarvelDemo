//
//  HeroDetailViewController.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var hero: Hero?
    var comics: [Comic] = []
    let viewModel = HeroDetailVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let safeHero = hero else {
            self.displayErrorMessage("An error occured: No details available for selected hero.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        viewModel.requestHeroRecommendations(hero: safeHero, controller: self) { upcomingComics in
            self.comics = upcomingComics
            self.enableUI()
        }
    }
    
    func enableUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "heroRecommendationCellID"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? HeroRecommendationCell {
            let comic = comics[indexPath.row]
            cell.itemImage.showLoading()
            loadImageAsync(urlStr: comic.imageUrl) { imgData in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? HeroRecommendationCell {
                    cell.itemImage.removeLoading()
                    let img:UIImage! = UIImage(data: imgData)
                    updateCell.itemImage.image = img
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "heroDetailHeaderID", for: indexPath) as? HeroDetailHeaderView {
                
                headerView.itemName.text = hero?.name ?? String()
                headerView.itemDescripton.text = hero?.hero_description ?? String()
                headerView.itemImage.showLoading()
                if let imgURLStr = hero?.photo_url {
                    loadImageAsync(urlStr: imgURLStr) { imgData in
                        if let updateCell = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? HeroDetailHeaderView {
                            updateCell.itemImage.removeLoading()
                            updateCell.itemImage.viewWithTag(9999)?.removeFromSuperview()
                            let img:UIImage! = UIImage(data: imgData)
                            updateCell.itemImage.image = img
                        }
                    }
                }
                
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}
