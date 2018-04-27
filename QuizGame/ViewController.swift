//
//  ViewController.swift
//  QuizGame
//
//  Created by Dillon K Lau on 4/25/18.
//  Copyright © 2018 Dillon K Lau. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
   
    //Segmented controller for Single or Multiplayer
    @IBOutlet weak var singleMultiController: UISegmentedControl!
    
    
    
    @IBAction func start(_ sender: Any) {
        
        
        if singleMultiController.selectedSegmentIndex == 0 //Index 0 is Single player
        {
            self.performSegue(withIdentifier: "Single", sender: self)
        }
        else if singleMultiController.selectedSegmentIndex == 1 //Index 1 is Multiplayer
        {
            self.performSegue(withIdentifier: "Multiplayer", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Single")
        {
            var controll = segue.destination as! SinglePlayer
            
            
            
        }
        else if(segue.identifier == "Multiplayer")
        {
            var controll = segue.destination as! Multiplayer
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

