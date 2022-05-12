//
//  RacingViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 7.04.22.
//

import UIKit
import CoreMotion


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
    
    @IBOutlet weak var accelerometerSwitch: UISwitch!
    
    //MARK: - Properties
    private enum Place {
        case left
        case center
        case right
    }
    
    private let motionManager = CMMotionManager()
    private var isStartAccselerometer: Bool = true
    
    private var position: Place = .center
    private let userName: String = SaveUserSettings.shared.userName ?? "Unknown user"
    private var userScore = 0
    private var duration: TimeInterval = 35 / (Double(SaveUserSettings.shared.speed) ?? 60)

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
        moveDownForObstructions()
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
    
    private func countUserScore() {
       userScore += 1
    }
    
    private func saveLastUserRecord() {
        let record = RecordGame(userName: userName, userScore: userScore, date: Date())
        SaveUserSettings.shared.record(recordGame: record)
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
    
    func moveDownForObstructions() {
        guard self.viewMainScreenRacing.bounds.contains(self.leftSideObstructionImageView.frame) || self.leftImageViewTopConstraint.constant < 0 else {
            self.leftImageViewTopConstraint.constant = -150
            self.centerImageViewTopConstraint.constant = -150
            self.rightImageViewTopConstrainr.constant = -150
            self.countUserScore()
            self.view.layoutIfNeeded()
            duration = max(0.04, duration * 0.7)
            return self.repeatAnimation()
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: { [weak self] in
            guard let self = self else { return }
            self.leftImageViewTopConstraint.constant += 25
            self.centerImageViewTopConstraint.constant += 65
            self.rightImageViewTopConstrainr.constant += 40
            self.view.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.repeatAnimation()
        })
    }

    func repeatAnimation() {
        moveDownForObstructions()
    }

    private func moveWithAccelerometer(_ flag: Bool) {
        if flag {
            viewForNavigationButtons.isHidden = true
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 1 / 60
                motionManager.startAccelerometerUpdates(to: .main) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if let data = data {
                        if data.acceleration.x > 0.08 {
                            self.setMouseImagePosition(to: .right)
                        }
                        if data.acceleration.x < -0.08 {
                            self.setMouseImagePosition(to: .left)
                        }
                    }
                }
            }
        } else {
            viewForNavigationButtons.isHidden = false
            return
        }
    }
    
    
    func showGameOverVC() {
        saveLastUserRecord()
        motionManager.stopAccelerometerUpdates()
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
    
    @IBAction func accelerometerSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            viewForNavigationButtons.isHidden = true
            moveWithAccelerometer(isStartAccselerometer)
        } else {
            viewForNavigationButtons.isHidden = false
            motionManager.stopAccelerometerUpdates()
        }
    }
}
