//
//  ViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 25.03.22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userScoreLabel: UILabel!
    
    @IBOutlet weak var lastRecordLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    //MARK: - Properties
    
    private let pin = "366"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuWidth.constant = 0
        
        blurView.isHidden = true
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBlur))
        blurView.addGestureRecognizer(tapGesture)
        blurView.isUserInteractionEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = SaveUserSettings.shared.userName ?? "User Name"
        userImage.image = SaveUserSettings.shared.userImage ?? UIImage(systemName: "person.circle")
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
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
    
    @IBAction func settingTapped(_ sender: Any) {
        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        self.navigationController?.pushViewController(settingsViewController, animated: true)
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
                self?.presentAlert(text: "Great! Let's start the game")
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
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userImage.image = image
        SaveUserSettings.shared.userImage = image
        self.dismiss(animated: true, completion: nil)
     
        }
    }

