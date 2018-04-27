//
//  Multiplayer.swift
//  QuizGame
//
//  Created by Dillon K Lau on 4/25/18.
//  Copyright © 2018 Dillon K Lau. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class Multiplayer: UIViewController ,MCBrowserViewControllerDelegate, MCSessionDelegate {
    //player 1 will awlays be in color
    @IBOutlet weak var player2: UIImageView! //yellow
    @IBOutlet weak var player3: UIImageView! //green
    @IBOutlet weak var player4: UIImageView! //blue
    
    //Multiplayer Session
    var session: MCSession!
    
    //Quiz
    var quizGame = [Question]()
    var numberOfTotalQuestions: Int!
    var questionsTopic: String!
    var currentQuestionNumber: Int!
    
    
    //Json parsing
    var currentUrlString = String()
    
    //players
    var players =  [Player]()
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async(execute: {
            //let playerIndex = (self.getPlayerIndex(by:peerID))!
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                switch receivedString {
                case "NEW_GAME":
                    print("hi")
                    //self.game?.loadNewQuiz()
                    
                case "GO_BACK":
                    _ = self.navigationController?.popViewController(animated: true)
                default:
                    print("hi")
                }
            }
        })
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: player2.image!), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgImg = context.createCGImage(output!, from: output!.extent)
        let process = UIImage(cgImage: cgImg!)
        player2.image = process //Grays player 2
        
        player3.image = process //Grays player 3
        
        player4.image = process //Grays player 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func readJSONData(_ object: [String: AnyObject]) {
        
        
        
        if let topic = object["topic"] as? String, let numberOfQuestions = object["numberOfQuestions"] as? Int, let questions = object["questions"] as? [[String: AnyObject]] {
            
            for questions in questions {
                
                var optionAA: String!
                var optionBB: String!
                var optionCC: String!
                var optionDD: String!
                
                //print(questions["options"]!)
                
                if let options = questions["options"] as? [String: AnyObject]
                {
                    optionAA = options["A"]! as! String
                    optionBB = options["B"]! as! String
                    optionCC = options["C"]! as! String
                    optionDD = options["D"]! as! String
                }
                let number = Int(truncating: questions["number"] as! NSNumber)
                let question = questions["questionSentence"] as! String
                let correctAnswer = questions["correctOption"] as! String
                
                quizGame.append(Question(number: number, question: question, optionA: optionAA, optionB: optionBB, optionC: optionCC, optionD: optionDD, answer: correctAnswer))
           
                
            }
            
            questionsTopic = topic
            numberOfTotalQuestions = numberOfQuestions
            
            
        }
    }
    func getJSONData()
    {
        let semaphore = DispatchSemaphore(value: 0);
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        currentUrlString = urlString
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        // create a data task
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let result = data{
                do{
                    let object = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = object as? [String: AnyObject] {
                        self.readJSONData(dictionary)
                    }
                }
                catch{
                    print("Error")
                }
                semaphore.signal()
            }
            
        })
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    func getJSONData2()
    {
        let semaphore = DispatchSemaphore(value: 0);
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json"
        currentUrlString = urlString
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        // create a data task
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let result = data{
                do{
                    let object = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = object as? [String: AnyObject] {
                        self.readJSONData(dictionary)
                    }
                }
                catch{
                    print("Error")
                }
                semaphore.signal()
            }
            
        })
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class Player {
    var peerId: MCPeerID
    
    var image: UIImage
    
    var direction = 0 // north, south, east, west
    
    var score = 0
    
    var selectedAnswer = ""
    
    func randPicture() -> UIImage{
        let randNum = arc4random_uniform(4)+1
        let icon = UIImage(named: "icon\(randNum)")
        return icon!
    }
    
    init(peerId: MCPeerID) {
        self.peerId = peerId
        self.image = UIImage()
        self.image = randPicture()
    }
    
    init(peerId: MCPeerID, image: UIImage) {
        self.peerId = peerId
        self.image = image
    }
    
    func awardPoints() {
        self.score += 10
    }
}

