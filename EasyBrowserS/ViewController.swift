//
//  ViewController.swift
//  EasyBrowserS
//
//  Created by Josue Hernandez on 12/31/21.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Properties
    let webSites = ["google.com", "apple.com", "raywenderlich.com", "unavailable"]
    static let showDetailSegueIdentifier = "WebDetailSegue"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Self.showDetailSegueIdentifier,
           let destination = segue.destination as? DetailView,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
                let pageToVisit = webSites[indexPath.row]
                if pageToVisit.contains(".com"){
                    let reminder = webSites[indexPath.row]
                    destination.configure(with: reminder)
                } else {
                    // notify via alert
                    showAlert()
                }
        }

    }

    // MARK: - General Methods
    func showAlert(){
        let alert = UIAlertController(title: "Invalid",
                                      message: "The page you're trying to open is unavailable",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView datasource
extension ViewController {
    
    static let listCellIdentifier = "cell"

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: Self.listCellIdentifier)
         if (cell == nil) {
             cell = UITableViewCell(style: .default, reuseIdentifier: Self.listCellIdentifier)
         }
        cell?.textLabel?.text = webSites[indexPath.row]
         return cell!
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.webSites.count
    }
}

// MARK: - TableView delegate
extension ViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
