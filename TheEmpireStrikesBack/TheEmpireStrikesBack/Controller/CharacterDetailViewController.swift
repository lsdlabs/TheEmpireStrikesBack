//
//  CharacterDetailViewController.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/30/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var homeworldLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    
    // MARK: - Properties
    
    var person: CharacterData?
    var species: Species?
    var speciesArray: [Species] = []
    var homeworld: Homeworld?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignValuesToLabelsContainingCharacterData()
        
        getSpecies()
        getHomeworld()
    }
    
    func assignValuesToLabelsContainingCharacterData(){
        if let name = person?.name {
            nameLabel.text = "\(name)"
        } else {
            nameLabel.text = "Name Unknown"
        }
        if let birthYear = person?.birth_year {
            birthYearLabel.text = "\(birthYear)"
        } else {
            birthYearLabel.text = "Birth Year Unknown"
        }
        if let gender = person?.gender {
            genderLabel.text = "\(gender)"
        } else {
            genderLabel.text = "Gender Unknown"
        }
    }
    
    func getSpecies() {
        guard let speciesURL = getSpeciesURL() else {
            return
        }
        for url in speciesURL {
            getSpeciesData(from: url)
        }
    }
    
    func getSpeciesURL() -> [String]? {
        return person?.species
    }
    
    func getSpeciesData(from url: String) {
        let session = URLSession(configuration: .default)
        
        guard let speciesURL = URL(string: url) else {
            print("Error: Cannot create a species URL")
            return
        }
        let urlRequest = URLRequest(url: speciesURL)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error calling GET on speciesUrl")
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            self.species = self.parseSpecies(data: data)
            guard let species = self.species else {
                return
            }
            self.speciesArray.append(species)
            DispatchQueue.main.async {
                self.updateLabels()
            }
        }
        task.resume()
    }
    
    func parseSpecies(data: Data) -> Species? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Species.self, from: data)
            
            return result
        } catch {
            print("Species- Decoding Error: \(error)")
            return nil
        }
    }
    
    func updateLabels() {
        if let species = species?.name {
            speciesLabel.text = "\(species)"
        } else {
            speciesLabel.text = "Species Unknown"
        }
        if let homeworld = homeworld?.name {
            homeworldLabel.text = "\(homeworld)"
        } else {
            homeworldLabel.text = "Homeworld Unknown"
        }
    }
    
    func getHomeworld() {
        guard let homeworldURL = getHomeworldURL() else {
            return
        }
        getHomeworldData(from: homeworldURL)
    }
    
    func getHomeworldURL() -> String? {
        return person?.homeworld
    }
    
    func getHomeworldData(from url: String){
        let session = URLSession(configuration: .default)
        guard let homeworldURL = URL(string: url) else {
            print("Error: Cannot create a homeworld URL")
            return
        }
        let urlRequest = URLRequest(url: homeworldURL)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error calling GET on homeworldUrl")
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            self.homeworld = self.parseHomeworld(data: data)
            DispatchQueue.main.async {
                self.updateLabels()
            }
        }
        task.resume()
    }
    
    func parseHomeworld(data: Data) -> Homeworld? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Homeworld.self, from: data)
            return result
        } catch {
            print("Homeworld- Decoding Error: \(error)")
            return nil
        }
    }
}
