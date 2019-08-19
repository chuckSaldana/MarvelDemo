//
//  ViewControllerAdditions.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 19/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "New alert!", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
