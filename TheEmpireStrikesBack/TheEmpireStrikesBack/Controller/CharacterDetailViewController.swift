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
    
    // MARK: - Properties
    
    var person: CharacterData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
