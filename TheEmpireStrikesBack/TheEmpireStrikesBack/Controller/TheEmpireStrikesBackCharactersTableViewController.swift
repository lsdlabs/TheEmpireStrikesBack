//
//  ViewController.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/22/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import UIKit

class TheEmpireStrikesBackCharactersTableViewController: UITableViewController {
    
    var characterURLs = [String]()
    var characters: [CharacterData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTheEmpireStrikesBackCharacters()
    }
    
    func theEmpireStrikesBackUrl() -> URL? {
        let starWarsUrl = "https://swapi.co/api/films/2"
        guard let url = URL(string: starWarsUrl) else {
            print("URL Error")
            return nil
        }
        return url
    }
    
    func fetchTheEmpireStrikesBackCharacters() {
        guard let starWarsUrl = theEmpireStrikesBackUrl() else {
            print("URL Error")
            return
        }
        let urlRequest = URLRequest(url: starWarsUrl)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, repsonse, error) in
            if let error = error {
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
                print(error)
            }
        }
        task.resume()
    }
    
    
    func getCharacters(from characterURLArray: [String]) {
        for url in characterURLArray{
            guard let characterUrl = URL(string: url) else {
                print("URL Error")
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
            guard let data = data else {
                return
            }
            
            guard let currentCharacter = self.parse(data: data) else { return }
            self.characters.append(currentCharacter)
        }
        task.resume()
    }
    
    func parse(data: Data) -> CharacterData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CharacterData.self, from: data)
            print("Character Name:")
            print(result.name)
            return result
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
}
