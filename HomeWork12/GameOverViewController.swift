//
//  GameOverViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 8.04.22.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var gameOverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverLabel.layer.cornerRadius = 10
        gameOverLabel.layer.masksToBounds = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Main Screen", style: .done, target: self, action: #selector(backToInitial(sender:)))
    }
    
    @objc private func backToInitial(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
   }
}
