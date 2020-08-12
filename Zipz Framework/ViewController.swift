//
//  ViewController.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 05/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.text = "zipz.user@zipz.dev"
        }
    }
    
    @IBOutlet weak var firstNametextField: UITextField! {
        didSet {
            firstNametextField.text = "Zipz"
        }
    }
    
    @IBOutlet weak var lastNameTextField: UITextField!  {
        didSet {
            lastNameTextField.text = "User"
        }
    }
    
    @IBOutlet weak var genderTextField: UITextField! {
        didSet {
            genderTextField.text = "other"
        }
    }
    
    @IBOutlet weak var birthdayTextField: UITextField!  {
        didSet {
            birthdayTextField.text = "1980-01-01"
        }
    }
    
    @IBOutlet weak var cpfTextField: UITextField!  {
        didSet {
            cpfTextField.text = "11223344556"
        }
    }
    
    // MARK: - View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap =  UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = APIToken.read()?.token else {
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "presentPermissions", sender: self)
        }
    }
    
    // MARK: - IBAction
    @IBAction func loginButtonAction(_ sender: Any)
    {
        guard let email = emailTextField.text,
            let firstName = firstNametextField.text,
            let lastName = lastNameTextField.text,
            let gender = genderTextField.text,
            let birthday = birthdayTextField.text,
            let cpf = cpfTextField.text else {
                
                debugLog("Required field/s is/are missing.")
                return
        }
        let cpfNumber = Int(cpf) ?? 0
        let parameters: [String:Any] = ["email":email, "first_name":firstName, "last_name":lastName, "gender":gender, "date_of_birth":birthday, "cpf":cpfNumber]
        
        ZipzAuth().registerUser(with: parameters) { (uuid, error) in
            
            guard let uuid = uuid else {
                debugLog("REGISTER error: \(error ?? "unknown")")
                return
            }
            
            ZipzAuth().initUser(with: uuid) { (token, error) in
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "presentPermissions", sender: self)
                }
            }
        }
    }
    
    // MARK: - OBJC Methods
    @objc private func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
}

