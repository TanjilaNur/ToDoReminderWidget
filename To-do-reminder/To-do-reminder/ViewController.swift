//
//  ViewController.swift
//  To-Do-Widget
//
//  Created by TanjilaNur-00115 on 14/9/23.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    
    ///Create a background view for the input text field
    private let appTitle: UILabel = {
        let appTitle = UILabel()
        appTitle.text = "To-Do Tracker"
        appTitle.textColor = .black
        appTitle.font = .systemFont(ofSize: 30, weight: .bold)
        appTitle.textAlignment = .left
        
        return appTitle
    }()
    
    ///Text field for taking to-do Item
    private let inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter Your Next To Do Item"
        inputTextField.backgroundColor = .white
        inputTextField.layer.cornerRadius = 8
        inputTextField.tintColor = .black
        
        // Create a leftView with a width of 10 points
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: inputTextField.frame.height))
        inputTextField.leftView = leftView
        inputTextField.leftViewMode = .always // Display the left view always
        
        return inputTextField
    }()
    
    ///Button to submit the to-do item of the text field
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = .blue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        
        return saveButton
    }()
    
    private let nextTaskLabel : UILabel = {
        let nextToDoTask = UILabel()
        nextToDoTask.text = "Next: Nothing to do!"
        nextToDoTask.textColor = .black
        nextToDoTask.font = .systemFont(ofSize: 30, weight: .bold)
        nextToDoTask.textAlignment = .center
        nextToDoTask.numberOfLines = 0
        
        return nextToDoTask
    }()
    
    
    /// This method is called when the view controller's view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        
        view.addSubview(appTitle)
        
        view.addSubview(inputTextField)
        inputTextField.becomeFirstResponder()
        
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        view.addSubview(nextTaskLabel)
    }

    
    ///This method is called when the view controller's view has been laid out and its subviews have been properly positioned
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //set up constraints for appTitle
        appTitle.frame = CGRect(x: 20,
                                y: view.safeAreaInsets.top + 10,
                                width: view.frame.size.width - 40,
                                height: 70)
        
        //set up constraints for inputTextFiels
        inputTextField.frame = CGRect(x: 20,
                                      y: view.safeAreaInsets.top + (view.frame.size.height / 5),
                                      width: view.frame.size.width - 40,
                                      height: 60)
        
        //set up constraints for saveButton
        saveButton.frame = CGRect(x: 100,
                                  y: view.safeAreaInsets.top + (view.frame.size.height / 5) + 68,
                                  width: view.frame.size.width - 200,
                                  height: 50)
        
        nextTaskLabel.frame = CGRect(x: 20,
                                y: view.safeAreaInsets.top + (view.frame.size.height / 5) + 200,
                                width: view.frame.size.width - 40,
                                height: 70)
    }
    
    /// This function is called when the "Save" button is pressed by the user.
    @objc func saveButtonPressed(){
        inputTextField.resignFirstResponder()
        
        //Safely unwrap the optional 'inputTextField.text' and assign it to 'toDoItem' if not empty.
        guard let toDoItem = inputTextField.text, !toDoItem.isEmpty else {
            return
        }
        
        //Save to-do item in userdefaults
        let userDefaults = UserDefaults(suiteName: "group.widgetcache")
        userDefaults?.setValue(toDoItem, forKey: "toDoItem")
        print(toDoItem)
        
        nextTaskLabel.text = "Next: \(toDoItem)"
        
        //clear the input text field after saving toDoItem
        inputTextField.text = ""
        
        //reload widget for newly saved to-do
        WidgetCenter.shared.reloadAllTimelines()
    }

}

