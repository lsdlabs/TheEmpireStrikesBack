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
        
        nameLabel.text = person?.name
        birthYearLabel.text = person?.birth_year
        genderLabel.text = person?.gender
        
        getSpecies()
        getHomeworld()
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
            print("URL Error")
            return
        }
        let urlRequest = URLRequest(url: speciesURL)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
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
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func updateLabels() {
        speciesLabel.text = species?.name
        homeworldLabel.text = homeworld?.name
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
            print("URL Error")
            return
        }
        let urlRequest = URLRequest(url: homeworldURL)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
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
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
