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
    let usersScoresArray: [RecordGame] = SaveUserSettings.shared.usersScores.sorted(by: >)
    
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
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        let user = usersScoresArray[indexPath.row]
        let stringDate = user.stringDate
        
        cell.isUserInteractionEnabled = false
        cell.textLabel?.text =
        """
        User name: \(user.userName)
        User score: \(String(user.userScore))
        Date: \(stringDate)
        """
        return cell
    }
}
