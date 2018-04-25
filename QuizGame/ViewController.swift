//
//  ViewController.swift
//  QuizGame
//
//  Created by Dillon K Lau on 4/25/18.
//  Copyright © 2018 Dillon K Lau. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate{
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var selected: String!
    @IBOutlet weak var Single: UIButton!
    @IBOutlet weak var Multiplayer: UIButton!
    @IBAction func singleTouch(_ sender: UIButton) {
        var thing = Single
        var thing2 = Multiplayer
        thing?.backgroundColor = UIColor.black
        thing2?.backgroundColor = UIColor.clear
        selected = Single.currentTitle
    }
    @IBAction func multiTouch(_ sender: Any) {
        var thing = Single
        var thing2 = Multiplayer
        thing?.backgroundColor = UIColor.clear
        thing2?.backgroundColor = UIColor.black
        selected = Multiplayer.currentTitle
        
    }
    @IBAction func start(_ sender: Any) {
        if selected == "Single"
        {
        self.performSegue(withIdentifier: "Single", sender: self)
        }
        else if selected == "Multiplayer"
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
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
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

