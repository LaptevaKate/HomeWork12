//
//  RacingViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 7.04.22.
//

import UIKit

class RacingViewController: UIViewController {

    //MARK: - @IBOutlet
    
    @IBOutlet weak var mouseLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageViewTopConstrainr: NSLayoutConstraint!
    @IBOutlet weak var centerImageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewForNavigationButtons: UIView!
    @IBOutlet weak var viewMainScreenRacing: UIView!
    
    
    @IBOutlet weak var leftSideObstructionImageView: UIImageView!
    @IBOutlet weak var rightSideObstructionImageView: UIImageView!
    @IBOutlet weak var centerSideObstructionImageView: UIImageView!
    
    @IBOutlet weak var mouseImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //MARK: - Properties
    
    private enum Place {
        case left
        case center
        case right
    }
    
    private var position: Place = .center
    
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        initViews()
        
        selectColorToMouseImageView(mouseColor: SaveUserSettings.shared.mouseColor)
        
        leftSideObstructionImageView.image = selectKindOfObstruction(obstruction: SaveUserSettings.shared.obstruction) ?? UIImage(named: "cat")
        rightSideObstructionImageView.image = selectKindOfObstruction(obstruction: SaveUserSettings.shared.obstruction) ?? UIImage(named: "dog")
        centerSideObstructionImageView.image = selectKindOfObstruction(obstruction: SaveUserSettings.shared.obstruction) ?? UIImage(named: "owl")
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.mouseImageView.frame.intersects(self.leftSideObstructionImageView.frame) {
                timer.invalidate()
                self.showGameOverVC()
            } else if self.mouseImageView.frame.intersects(self.centerSideObstructionImageView.frame) {
                timer.invalidate()
                self.showGameOverVC()
            } else if self.mouseImageView.frame.intersects(self.rightSideObstructionImageView.frame) {
                timer.invalidate()
                self.showGameOverVC()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveDownForObstructions(mouseSpeed: Double(SaveUserSettings.shared.speed) ?? 90)
        setMouseImagePosition(to: .center)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Methods
    func initViews() {
        viewForNavigationButtons.layer.cornerRadius = 20
        viewForNavigationButtons.layer.masksToBounds = true
        
        viewMainScreenRacing.layer.cornerRadius = 20
        viewMainScreenRacing.layer.masksToBounds = true
    }

    func selectColorToMouseImageView(mouseColor: String) {
        let templateImage = mouseImageView.image?.withRenderingMode(.alwaysTemplate)
           mouseImageView.image = templateImage
        switch mouseColor {
        case "Green":
            return mouseImageView.tintColor = UIColor.green
        case "Red":
            return mouseImageView.tintColor = UIColor.red
        case "Blue":
            return mouseImageView.tintColor = UIColor.blue
        case "Black":
            return mouseImageView.tintColor = UIColor.black
        default:
            return mouseImageView.tintColor = UIColor.white
        }
}
    func selectKindOfObstruction(obstruction: String) -> UIImage? {
      
       switch obstruction {
       case "Cat":
           return UIImage(named: "cat")
       case "Dog":
           return UIImage(named: "dog")
       case "Owl":
           return UIImage(named: "owl")
       default:
           return UIImage(named: "tortoise")
       }
    }
    
  
    private func setMouseImagePosition(to position: Place) {
        let width = mouseImageView.frame.width
        
        switch position {
        case .left:
            mouseLeadingConstraint.constant = width * 0.25
        case .center:
            mouseLeadingConstraint.constant = width * 1.5
        case .right:
            mouseLeadingConstraint.constant = width * 2.75
        }
        view.layoutIfNeeded()
    }
    
    private func moveToRight() {
        switch position {
        case .left:
            position = .center
        case .center:
            position = .right
        default:
           break
        }
        setMouseImagePosition(to: position)
        updateButtons()
    }
    
    private func moveToLeft() {
        switch position {
        case .center:
            position = .left
        case .right:
            position = .center
        default:
           break
        }
        setMouseImagePosition(to: position)
        updateButtons()
    }
    
    private func updateButtons() {
        leftButton.isEnabled = position != .left
        rightButton.isEnabled = position != .right
    }
    
    private func moveMouseImageToRight() {
        switch position {
        case .left:
            setMouseImagePosition(to: .center)
        case .center:
            setMouseImagePosition(to: .right)
        default:
            break
        }
    }
    
    private func moveMouseImageToLeft() {
        switch position {
        case .center:
            setMouseImagePosition(to: .left)
        case .right:
            setMouseImagePosition(to: .center)
        default:
            break
        }
    }
    
    
    func moveDownForObstructions(mouseSpeed: Double) {
        guard self.viewMainScreenRacing.bounds.contains(self.leftSideObstructionImageView.frame) || self.leftImageViewTopConstraint.constant < 0 else {
            self.leftImageViewTopConstraint.constant = -150
            self.centerImageViewTopConstraint.constant = -150
            self.rightImageViewTopConstrainr.constant = -150
            self.view.layoutIfNeeded()
            return self.repeatAnimation(mouseSpeed: mouseSpeed)
        }
        UIView.animate(withDuration: 25 / mouseSpeed, delay: 0, options: [.curveLinear], animations: { [weak self] in
            guard let self = self else { return }
            self.leftImageViewTopConstraint.constant += 30
            self.centerImageViewTopConstraint.constant += 60
            self.rightImageViewTopConstrainr.constant += 50
            self.view.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.repeatAnimation(mouseSpeed: mouseSpeed)
        })
    }

    func repeatAnimation(mouseSpeed: Double) {
        moveDownForObstructions(mouseSpeed: mouseSpeed)
    }
    

    func showGameOverVC() {
        let gameOverVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gameOver") as! GameOverViewController
        self.navigationController?.pushViewController(gameOverVC, animated: true)
    }

    //MARK: - IBActions
    @IBAction func moveMouseToTheLeft(_ sender: Any) {
        UIView.animate(withDuration: 1,  animations: { [weak self] in
            self?.moveMouseImageToLeft()
        }) { [weak self] _ in
            self?.moveToLeft()
        }
    }
    
    
    @IBAction func moveMouseToTheRight(_ sender: Any) {
        UIView.animate(withDuration: 1,  animations: { [weak self] in
            self?.moveMouseImageToRight()
        }) { [weak self] _ in
            self?.moveToRight()
        }
    }
    
}
