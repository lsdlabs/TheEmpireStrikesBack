//
//  ViewController.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/22/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import UIKit

class TheEmpireStrikesBackCharactersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var characterURLs = [String]()
    var characters: [CharacterData] = []
    var isLoading = false
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        fetchTheEmpireStrikesBackCharacters()
    }
    
    
    // MARK: - Methods
    
    func getTheEmpireStrikesBackUrl() -> URL? {
        let starWarsUrl = "https://swapi.co/api/films/2"
        guard let url = URL(string: starWarsUrl) else {
            print("Error: Cannot create The Empire Strikes Back URL")
            return nil
        }
        return url
    }
    
    func fetchTheEmpireStrikesBackCharacters() {
        guard let starWarsUrl = getTheEmpireStrikesBackUrl() else {
            print("Error: Cannot get The Empire Strikes Back URL")
            return
        }
        let urlRequest = URLRequest(url: starWarsUrl)
        
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error calling GET on starWarsUrl")
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let theEmpireStrikesBackInfo = try decoder.decode(TheEmpireStrikesBack.self, from: data)
                self.characterURLs.append(contentsOf: theEmpireStrikesBackInfo.characters)
                self.getCharacters(from: self.characterURLs)
                
            } catch {
                print("TheEmpireStrikesBack- Decoding Error: \(error)")
            }
        }
        task.resume()
    }
    
    
    func getCharacters(from characterURLArray: [String]) {
        for url in characterURLArray{
            guard let characterUrl = URL(string: url) else {
                print("Error: Cannot create a character URL")
                return
            }
            getCharacterData(from: characterUrl)
        }
    }
    
    func getCharacterData(from url: URL) {
        let urlRequest = URLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task  = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error calling GET on characterUrl")
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            
            guard let currentCharacter = self.parse(data: data) else { return }
            self.characters.append(currentCharacter)
            
            if self.characters.count == self.characterURLs.count{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func parse(data: Data) -> CharacterData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CharacterData.self, from: data)
            return result
        } catch {
            print("CharacterData- Decoding Error: \(error)")
            return nil
        }
    }
    
    func setCellProperties(with cell: UITableViewCell) {
        
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        let selectedCellColor = UIColor.black
        backgroundView.backgroundColor = selectedCellColor
        cell.selectedBackgroundView = backgroundView
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetails" {
            if let destination = segue.destination as? CharacterDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let characterAtSelectedRow = characters[indexPath.row]
                    destination.person = characterAtSelectedRow
                }
            }
        }
    }
    
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return characters.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterNameCell", for: indexPath)
        if isLoading {
            cell.textLabel?.text = "Loading Characters..."
        } else {
            cell.textLabel?.text = "\(characters[indexPath.row].name)"
            setCellProperties(with: cell)
        }
        return cell
    }
}
