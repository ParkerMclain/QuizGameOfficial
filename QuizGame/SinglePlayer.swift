//
//  SinglePlayer.swift
//  QuizGame
//
//  Created by Dillon K Lau on 4/25/18.
//  Copyright © 2018 Dillon K Lau. All rights reserved.
//

import UIKit

class SinglePlayer: UIViewController {
    
    var quizGame = [Question]()
    var numberOfTotalQuestions: Int!
    var questionsTopic: String!
    var currentQuestionNumber: Int!
    
    //Game timer
    var gameTimer = Timer()
    var overallTimer = Timer()
    
    //Initalize game timer to 20
    var seconds = 20
    var waiting3Seconds: Bool!
    var timeStamp: Int!
    var gameEnded: Bool!
    
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var timerNotificationLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Single Player"
        
        restartButton.isHidden = true
        
        gameEnded = false
        
        //Assign tags to 4 answer choices
        buttonA.tag = 0
        buttonB.tag = 1
        buttonC.tag = 2
        buttonD.tag = 3
        
        //Sets game to begin with question 1
        currentQuestionNumber = 0
        waiting3Seconds = false
        
        setButtonBorders()
        clearButtonBorders()
        
        
        //Start game timer
        startTimer()
        
        getJSONData()
        
        loadQuestion()
        
    }
    
    func setButtonBorders()
    {
        buttonA.layer.borderWidth = 5
        buttonA.layer.cornerRadius = 15
        
        buttonB.layer.borderWidth = 5
        buttonB.layer.cornerRadius = 15
        
        buttonC.layer.borderWidth = 5
        buttonC.layer.cornerRadius = 15
        
        buttonD.layer.borderWidth = 5
        buttonD.layer.cornerRadius = 15
    }
    
    func clearButtonBorders()
    {
        buttonA.layer.borderColor = UIColor.clear.cgColor
        buttonB.layer.borderColor = UIColor.clear.cgColor
        buttonC.layer.borderColor = UIColor.clear.cgColor
        buttonD.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    //4 answer options are linked to this function
    //A = tag 0, B = tag 1, C = tag 3, D = tag 4
    @IBAction func answerButtonTouched(_ sender: UIButton)
    {
        clearButtonBorders()
        sender.layer.borderColor = UIColor.red.cgColor
        
        let correct = quizGame[currentQuestionNumber].questionAnswer
        var number: Int = -1
        
        switch correct {
        case "A":
            number = 0
        case "B":
            number = 1
        case "C":
            number = 2
        case "D":
            number = 3
        default:
            number = -1
        }
        
        if sender.tag == number
        {
            attemptToLoadNextQuestion()
        }
        
    }
    
    func attemptToLoadNextQuestion()
    {
        clearButtonBorders()
        if waiting3Seconds == true
        {
            enableButtons()
            
            waiting3Seconds = false
        }
        
        if currentQuestionNumber < numberOfTotalQuestions-1
        {
            currentQuestionNumber = currentQuestionNumber + 1
            gameTimer.invalidate()
            seconds = 20
            startTimer()
            loadQuestion()
        }
        else
        {
            print("No more questions!")
            endGame()
        }
    }
    
    
    @IBAction func restartButtonClicked(_ sender: Any)
    {
        print("Restart Clicked")
        restartGame()
    }
    
    func endGame()
    {
        gameEnded = true
        restartButton.isHidden = false
        print("No more questions!")
        timerNotificationLabel.isHidden = true
        
        disableButtons()
        
    }
    
    
    func disableButtons()
    {
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
    }
    
    func enableButtons()
    {
        buttonA.isEnabled = true
        buttonB.isEnabled = true
        buttonC.isEnabled = true
        buttonD.isEnabled = true
    }
    
    
    
    @objc func updateTimer()
    {
        if gameEnded == false
        {
            
            if waiting3Seconds == true
            {
                if seconds == 20
                {
                    attemptToLoadNextQuestion()
                }
            }
            
            
            //Stops the timer once it hits 0
            if seconds <= 0
            {
                //This is where we will need to call a function to end the current question
                timerNotificationLabel.text = "\(seconds)"
                //gameTimer.invalidate()
                showCorrectAnswer()
            }
            else
            {
                seconds = seconds - 1
                if seconds <= 20
                {
                    timerNotificationLabel.text = "\(seconds)"
                }
            }
        }
    }
    
    func startTimer()
    {
        timerNotificationLabel.text = "\(seconds)"
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SinglePlayer.updateTimer)), userInfo: nil, repeats: true)
        //overallTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SinglePlayer.updateTimer)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readJSONData(_ object: [String: AnyObject]) {
        
        //print(object)
        
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
                
                //print("Number: \(questions["number"]!) Sentence: \(questions["questionSentence"]!)")
                
            }
            
            questionsTopic = topic
            numberOfTotalQuestions = numberOfQuestions
            
            
        }
    }
    
    func showCorrectAnswer()
    {
        seconds = 23
        //gameTimer.fire()
        
        disableButtons()
        
        clearButtonBorders()
        let correct = quizGame[currentQuestionNumber].questionAnswer
        switch correct {
        case "A":
            buttonA.layer.borderColor = UIColor.red.cgColor
        case "B":
            buttonB.layer.borderColor = UIColor.red.cgColor
        case "C":
            buttonC.layer.borderColor = UIColor.red.cgColor
        case "D":
            buttonD.layer.borderColor = UIColor.red.cgColor
        default:
            print("Error.")
        }
        
        waiting3Seconds = true
        
    }
    
    
    func getJSONData()
    {
        let semaphore = DispatchSemaphore(value: 0);
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json"
        
        
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
    
    func restartGame()
    {
        gameEnded = false
        
        restartButton.isHidden = true
        
        //Sets game to begin with question 1
        currentQuestionNumber = 0
        waiting3Seconds = false
        
        setButtonBorders()
        clearButtonBorders()
        
        
        //Start game timer
        seconds = 20
        
        quizGame.removeAll()
        
        getJSONData()
        
        loadQuestion()
        
        timerNotificationLabel.isHidden = false
        
        enableButtons()
    }
    
    func testPrintArray()
    {
        //print(quizGame.count)
        for element in quizGame
        {
            print(element.questionNumber)
        }
    }
    
    func loadQuestion()
    {
        questionNumberLabel.text = "Question \(quizGame[currentQuestionNumber].questionNumber) of \(numberOfTotalQuestions!)"
        questionLabel.text = quizGame[currentQuestionNumber].questionQuestion
        buttonA.setTitle(quizGame[currentQuestionNumber].questionOptionA, for: .normal)
        buttonB.setTitle(quizGame[currentQuestionNumber].questionOptionB, for: .normal)
        buttonC.setTitle(quizGame[currentQuestionNumber].questionOptionC, for: .normal)
        buttonD.setTitle(quizGame[currentQuestionNumber].questionOptionD, for: .normal)
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

class Question {
    
    var questionNumber: Int
    var questionQuestion: String
    var questionOptionA: String
    var questionOptionB: String
    var questionOptionC: String
    var questionOptionD: String
    var questionAnswer: String
    
    init(number: Int, question: String, optionA: String, optionB: String, optionC: String, optionD: String, answer: String) {
        
        questionNumber = number
        questionQuestion = question
        questionOptionA = optionA
        questionOptionB = optionB
        questionOptionC = optionC
        questionOptionD = optionD
        questionAnswer = answer
    }
}
