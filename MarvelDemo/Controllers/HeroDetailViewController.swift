//
//  HeroDetailViewController.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var photoImgV: UIImageView!
    @IBOutlet weak var descriptionTxtV: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var hero: Hero?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let safeHero = hero else {
            self.displayErrorMessage("An error occured: No details available for selected hero.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
