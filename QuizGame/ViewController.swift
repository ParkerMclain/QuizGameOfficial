//
//  ViewController.swift
//  QuizGame
//
//  Created by Dillon K Lau on 4/25/18.
//  Copyright © 2018 Dillon K Lau. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    //Multiplayer Session
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    var imgNumber = Int()
    
    //players
    var playerCount = Int()
    
   
    //Segmented controller for Single or Multiplayer
    @IBOutlet weak var singleMultiController: UISegmentedControl!
    
    
    
    @IBAction func start(_ sender: Any) {
        
        
        if singleMultiController.selectedSegmentIndex == 0 //Index 0 is Single player
        {
            self.performSegue(withIdentifier: "Single", sender: self)
        }
        else if singleMultiController.selectedSegmentIndex == 1 //Index 1 is Multiplayer
        {
            if players.count > 1 && players.count <= 4
            {
                let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: "start")
                
                do{
                    try players[0].playerSession.send(dataToSend, toPeers: players[0].playerSession.connectedPeers, with: .unreliable)
                }
                catch let err {
                    //print("Error in sending data \(err)")
                }
                
                self.performSegue(withIdentifier: "Multiplayer", sender: self)
            }
            else
            {
                let errorAlert = UIAlertController(title: "Error", message: "Invalid number of players. Multiplayer requires 2-4 players.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
            }
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
        
        let context = CIContext(options: nil)
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Connect",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)
        
        imgNumber = 0
        
        //players.append(Player(peerId: self.peerID, img: imgNumber))
        players.append(Player(peerId: self.peerID, img: imgNumber, pSession: self.session))
        assistant.start()
        session.delegate = self
        browser.delegate = self
        
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func rightButtonAction(sender: AnyObject) {
        present(browser, animated: true, completion: nil) 
    }
    
    @objc func sendData()
    {
        
        //let msg = messageTF.text
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: "")
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        
        //updatePlayers()
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("Cancelled Browser")
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            imgNumber = imgNumber + 1
            print("My session: \(session)")
            //players.append(Player(peerId: peerID, img: imgNumber))
            players.append(Player(peerId: peerID, img: imgNumber, pSession: session))
            sendData()
            //playerCount += 1
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("Im in here ...")
        
        
        /*
        if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            //self.updateChatView(newText: receivedString, id: peerID)
            self.updatePlayers()
        }*/
        
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                if receivedString == "start"
                {
                    print("Hit the segue")
                    self.performSegue(withIdentifier: "Multiplayer", sender: self)
                }
            }
            
            //let playerIndex = (self.getPlayerIndex(by:peerID))!
            
            /*
             if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int {
             //self.updatePlayers(number: receivedString, id: peerID)
             print(receivedString)
             if receivedString == self.playerCount
             {
             self.playerCount = receivedString
             }
             }*/
            
            
            
        })
        
        
        
        
        /*
        if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            
            if receivedString == "start"
            {
                print("Hit the segue")
                self.performSegue(withIdentifier: "Multiplayer", sender: self)
            }
            
            //self.updateChatView(newText: receivedString, id: peerID)
            //self.updatePlayers()
        }*/
        /*
         DispatchQueue.main.async(execute: {
         //let playerIndex = (self.getPlayerIndex(by:peerID))!
         
         if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int {
         //self.updatePlayers(number: receivedString, id: peerID)
         print(receivedString)
         if receivedString == self.playerCount
         {
         self.playerCount = receivedString
         }
         }
         })
         */
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}

