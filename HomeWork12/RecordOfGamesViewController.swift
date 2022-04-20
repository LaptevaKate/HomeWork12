//
//  RecordOfGamesViewController.swift
//  HomeWork12
//
//  Created by Екатерина Лаптева on 18.04.22.
//

import UIKit

class RecordOfGamesViewController: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet private weak var scoresTableView: UITableView!
    //MARK: - Properties
    let usersScoresArray: [RecordGame] = SaveUserSettings.shared.usersScores.values.map({$0}).sorted(by: >)
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        scoresTableView.dataSource = self
    }
}
//MARK: - UITableViewDataSource 
extension RecordOfGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersScoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = usersScoresArray[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        let stringDate = formatter.string(from: user.date)
        
        cell.isUserInteractionEnabled = false
        cell.textLabel?.text = "User name: \(user.userName)\nUser score: \(String(user.userScore))\nDate: \(stringDate)"
        
        return cell
    }
}
