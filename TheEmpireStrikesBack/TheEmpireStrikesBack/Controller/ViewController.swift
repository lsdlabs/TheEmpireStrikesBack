//
//  ViewController.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/22/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            print("Data Retrieved.  Amount:")
            print(data)
            
            let decoder = JSONDecoder()
            let theEmpireStrikesBackInfo = try! decoder.decode(TheEmpireStrikesBack.self, from: data)
            
            self.characterURLs.append(contentsOf: theEmpireStrikesBackInfo.characters)
            print(self.characterURLs)
        }
        task.resume()
    }
}
