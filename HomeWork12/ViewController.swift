//
//  ViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 25.03.22.
//

import UIKit

class ViewController: UIViewController {
  
    
    
    //MARK: - Properties
   
    private let pin = "366"
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuWidth.constant = 0
        
        blurView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBlur))
        blurView.addGestureRecognizer(tapGesture)
        blurView.isUserInteractionEnabled = false
        
        
    }
   
    //MARK: - Methods
    
    @objc private func dismissBlur() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.blurView.isHidden = true
            self.blurView.isUserInteractionEnabled = true
            self.menuWidth.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
       
    }

    
    
    //MARK: - IBActions
    
    @IBAction func showMenuOptions(_ sender: Any) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.blurView.isHidden = false
            self.blurView.isUserInteractionEnabled = true
           
            self.menuWidth.constant = 300
            self.view.layoutIfNeeded()
        }, completion: nil)

        
        
    }
    
    
    @IBAction func startGameButton(_ sender: Any) {
        presentPinAlert()
    }
    
}

//MARK: - ViewController Extention
extension ViewController {
    func presentPinAlert() {
        let alert = UIAlertController(title: "Pin Question", message: "How many days in a high year?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter value to start the game"
            textField.keyboardType = .decimalPad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            guard let text = alert.textFields?.first?.text else { return }
            if text == self?.pin {
                self?.presentAlert(text: "You are right. Let's start the game")
            } else {
                self?.presentAlert(text: "Refresh your knowledge and try again")
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func presentAlert(text: String) {
        let alert = UIAlertController(title: "Result", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
