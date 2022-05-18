//
//  SettingsViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 31.03.22.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var mouseColorPickerView: UIPickerView!
    @IBOutlet weak var obstructionPickerView: UIPickerView!
    @IBOutlet weak var mouseSpeed: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Properties
    private let mouseColors = ["Green", "Red", "Blue", "Black"]
    private let obstructionForMoving = ["Cat", "Dog", "Owl"]
    private var mouseColorValue: String?
    private var obstructionValue: String?
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mouseColorPickerView.delegate = self
        mouseColorPickerView.dataSource = self
        obstructionPickerView.delegate = self
        obstructionPickerView.dataSource = self
        
        mouseSpeed.keyboardType = .numberPad
        
        addDoneButtonOnKeyboard()
        
        setupSettings()
        
        registerKeybordNotification()
    }
    
    //MARK: - Methods
    func setupSettings() {
        let savedData = SaveUserSettings.shared
        userNameTextField.text = savedData.userName
        mouseSpeed.text = savedData.speed
        if let mouseValueInt = mouseColors.firstIndex(where: {$0 == savedData.mouseColor}) {
            mouseColorPickerView.selectRow(mouseValueInt, inComponent: 0, animated: false)
        }
        if let obstructionValue = obstructionForMoving.firstIndex(where: {$0 == savedData.obstruction}) {
            obstructionPickerView.selectRow(obstructionValue, inComponent: 0, animated: false)
        }
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        mouseSpeed.inputAccessoryView = doneToolbar
        userNameTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        mouseSpeed.resignFirstResponder()
        userNameTextField.resignFirstResponder()
    }
    
    //MARK: - IBActions
    @IBAction func saveButton(_ sender: Any) {
        SaveUserSettings.shared.userName = userNameTextField.text?.isEmpty == true ? nil : userNameTextField.text
        SaveUserSettings.shared.speed = mouseSpeed.text ?? ""
        SaveUserSettings.shared.mouseColor = mouseColorValue ?? mouseColors[0]
        SaveUserSettings.shared.obstruction = obstructionValue ?? obstructionForMoving[0]
    
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SettingsViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.restorationIdentifier == "mouse"{
            return mouseColors.count
        } else if pickerView.restorationIdentifier == "obstruction" {
            return obstructionForMoving.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.restorationIdentifier == "mouse"{
            return mouseColors[row]
        } else if pickerView.restorationIdentifier == "obstruction" {
            return obstructionForMoving[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.restorationIdentifier == "mouse"{
            mouseColorValue = mouseColors[row]
        } else if pickerView.restorationIdentifier == "obstruction" {
            obstructionValue = obstructionForMoving[row]
        }
    }
}
//MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    private func registerKeybordNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeybord(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeybord(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc func willShowKeybord(_ nofication: NSNotification) {
            guard let info = nofication.userInfo,
                  let keybordSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
                CrashlyticsManager.makeError(reason: .unwrap)
                return }
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keybordSize.height, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
        }
        
        @objc func willHideKeybord(_ nofication: NSNotification) {
            guard let info = nofication.userInfo,
                  let _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
                CrashlyticsManager.makeError(reason: .unwrap)
                return }
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
        }
}
