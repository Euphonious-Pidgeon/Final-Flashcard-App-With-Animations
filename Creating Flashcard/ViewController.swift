//
//  ViewController.swift
//  Creating Flashcard
//
//  Created by Kevin Li on 3/12/22.
//  //updated on 3/22 for next lab

import UIKit

class ViewController: UIViewController {
    
    
    struct Flashcard {
        var question: String
        var answer: String
    }
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //array to hold flashcards
    var flashcards = [Flashcard]()
    
    //current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //read saved flashcards
        readSavedFlashcards()
        
        //adding initial flashcard if needed
        if flashcards.count == 0{
            updateFlashcard(question: "Welcome!", answer: "Click the + to create a flashcard")
        } else{
            updateLabels()
            updateNextPrevButtons()
        }
        
        //center the text
        frontLabel.textAlignment = .center
        backLabel.textAlignment = .center
    }
    
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            if self.frontLabel.isHidden == false{
                self.frontLabel.isHidden = true
            }
            //toggles off
            else{
                self.frontLabel.isHidden = false
            }
        }
    }
    
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)

        flashcards.append(flashcard)
        print("Flashcard added, we now have \(flashcards.count) flashcards")
        
        //update index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        
        //center the text
        frontLabel.textAlignment = .center
        backLabel.textAlignment = .center
        
        //save to disk
        saveAllFlashcardsTodisk()
    }
    
    
    //this function connects creationViewController to ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
    func updateNextPrevButtons(){
        //disable next button if at the end of index
        if currentIndex == flashcards.count-1{
            nextButton.isEnabled = false
        } else{
            nextButton.isEnabled = true
        }
        //disable prev button if at the beginning of index
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else{
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        //get curren flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // increase index
        currentIndex = currentIndex+1
        
        //update buttons
        updateNextPrevButtons()
        
        animateCardOut()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        // decrease index
        currentIndex = currentIndex-1
        
        //update buttons
        updateNextPrevButtons()
        
        animateCardOutLeft()
    }
    
    
    //animation for swiping right
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)}, completion: { finished in
                //update labels
                self.updateLabels()
                self.animateCardIn()})
    }
    
    func animateCardIn(){
        //start on the right side
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        //animate card going back to its original position
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
            }
        }
    
    
    //animation for swiping left
    func animateCardOutLeft(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)}, completion: { finished in
                //update labels
                self.updateLabels()
                self.animateCardInLeft()})
    }
    
    func animateCardInLeft(){
        //start on the right side
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        //animate card going back to its original position
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
            }
        }
    
    func saveAllFlashcardsTodisk(){
        //convert flashcards array to dict to avoid crash
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question" : card.question, "answer" : card.answer]
        }
        
        //save array on disk using UserDefaults so the array does not get wiped upon close
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //log it
        print("Flashcard saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        //read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]]{
            
            //when we know for sure that there is an array, we do this:
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all flashcard in flashcard array
            flashcards.append(contentsOf: savedCards)
        }
        
        
    }
    


}

