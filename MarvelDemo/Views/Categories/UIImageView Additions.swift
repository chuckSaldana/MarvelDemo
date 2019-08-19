//
//  UIViewAdditions.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.tag = 9999
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
    }
    
    func removeLoading() {
        self.viewWithTag(9999)?.removeFromSuperview()
    }
}
