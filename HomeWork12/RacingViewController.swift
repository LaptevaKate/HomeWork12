//
//  RacingViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 7.04.22.
//

import UIKit

class RacingViewController: UIViewController {

    //MARK: - @IBOutlet
    
    
    @IBOutlet weak var bottomLeftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRightImageViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewForNavigationButtons: UIView!
    @IBOutlet weak var viewMainScreenRacing: UIView!
    
    
    @IBOutlet weak var leftSideObstructionImageView: UIImageView!
    @IBOutlet weak var rightSideObstructionImageView: UIImageView!
    @IBOutlet weak var mouseImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //MARK: - Properties
    
    var position: Int = 0 {
        didSet {
            if position >= 1 {
                rightButton.isEnabled = false
            } else if position > -1 && position < 1 {
                rightButton.isEnabled = true
                leftButton.isEnabled = true
            } else {
                leftButton.isEnabled = false
            }
       }
 }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveDownForObstructions(mouseSpeed: Double(SaveUserSettings.shared.speed) ?? 0)
   
    }
    
    //MARK: - Methods
    func initViews() {
        viewForNavigationButtons.layer.cornerRadius = 20
        viewForNavigationButtons.layer.masksToBounds = true
        
        viewMainScreenRacing.layer.cornerRadius = 20
        viewMainScreenRacing.layer.masksToBounds = true
    }

    func moveDownForObstructions(mouseSpeed: Double) {
        UIView.animate(withDuration: mouseSpeed, delay: 0, options: [], animations: {
            self.bottomLeftImageViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.bottomLeftImageViewConstraint.constant = 600
        }
        UIView.animate(withDuration: mouseSpeed, delay: 1, options: [], animations: {
            self.bottomRightImageViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            self.bottomRightImageViewConstraint.constant = 600
            self.repeatAnimation(mouseSpeed: mouseSpeed)
        }
    }
    
  
    
    func repeatAnimation(mouseSpeed: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            self.moveDownForObstructions(mouseSpeed: mouseSpeed)
        })
    }

    //MARK: - IBActions
    @IBAction func moveMouseToTheLeft(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {self.mouseImageView.frame.origin.x -= 100
        }) { _ in
            self.position -= 1
        }
    }
    
    
    @IBAction func moveMouseToTheRight(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {self.mouseImageView.frame.origin.x += 100
        }) { _ in
            self.position += 1
        }
    }
}
