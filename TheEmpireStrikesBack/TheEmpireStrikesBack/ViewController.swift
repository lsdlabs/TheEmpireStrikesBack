//
//  ViewController.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/22/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchDataFromTheEmpireStrikesBack()
    }
    
    //Had to make it optional....would not allow me to return a string as the blow up case
    func theEmpireStrikesBackUrl() -> URL? {
        let starWarsUrl = "https://swapi.co/api/films/2"
        guard let url = URL(string: starWarsUrl) else {
            print("URL Error")
            return nil
        }
        return url
    }
    
    //will rename once this method gets modified when actually grabbing the characters...baby steps
    func fetchDataFromTheEmpireStrikesBack() {
        guard let starWarsUrl = theEmpireStrikesBackUrl() else {
            print("URL Error")
            return
        }
        let urlRequest = URLRequest(url: starWarsUrl)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, repsonse, error) in
            guard error == nil else {
                print("Error with GET request")
                print(error)
                return
            }
            
            if let responseData = data {
                print("Data Retrieved.  Amount:")
                print(responseData)
            }
            
        }
        task.resume()
    }
    
    
}

