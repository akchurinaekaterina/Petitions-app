//
//  ViewController.swift
//  Petitions app
//
//  Created by Ekaterina Akchurina on 25.09.2020.
//

import UIKit

class ViewController: UITableViewController {
    var urlString: String!
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        loadData(from: urlString)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = DetailViewController()
        dc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(dc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            showError()
        }
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func showCredits(){
        let creditsAlert = UIAlertController(title: "nil", message: "the data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        creditsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(creditsAlert, animated: true, completion: nil)
    }
    @objc func filterPetitions(){
        let filterAC = UIAlertController(title: "Enter Search text", message: nil, preferredStyle: .alert)
        filterAC.addTextField(configurationHandler: nil)
        filterAC.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak filterAC, weak self] action in
            if let text = filterAC?.textFields?[0].text {
                self?.filter(text)
            }
        }))
        filterAC.addAction(UIAlertAction(title: "Show all", style: .cancel, handler: { [weak self] action in
            if let urlString = self?.urlString {
            self?.loadData(from: urlString)
            }
        }))
        present(filterAC, animated: true, completion: nil) 
    }
    func filter(_ text: String){
        for petition in petitions {
            if petition.title.contains(text) || petition.body.contains(text) {
                filteredPetitions.append(petition)
            }
        }
        petitions = filteredPetitions
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func loadData(from urlString: String) {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
    }

}

