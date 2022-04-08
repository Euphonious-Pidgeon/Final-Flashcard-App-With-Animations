//
//  CreationViewController.swift
//  Creating Flashcard
//
//  Created by Kevin Li on 3/12/22.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //alert variable
    let alert = UIAlertController(title: "Error", message: "You are missing an input", preferredStyle: .alert)
    
    //ok message to dismiss the alert
    let okAction = UIAlertAction(title: "Ok", style: .default)
    //add it to alert variable in the if statement
    
    @IBAction func didTapOnDone(_ sender: Any) {
        //get question text
        let questionText = questionTextField.text
        //get answer text
        let answerText = answerTextField.text
        
        //give error if no inputs
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty{
            present(alert, animated: true)
            alert.addAction(okAction)
        } else{
            //call ViewController class to access updateFlashcard function
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!)
            
            dismiss(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
