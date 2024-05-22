//
//  ViewController.swift
//  MemoVault
//
//  Created by Matteo Orru on 18/05/24.
//
/*
 
The table view controller lists notes.
Tapping on a note should slide in a detail view controller that contains a full-screen text view.
 Notes should be loaded and saved using Codable.
 Add a toolbar items to the detail view controller like “delete” and “compose” and an action button to the navigation bar in the detail view controller that shares the text using UIActivityViewController.
 */

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        view.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 61/255, alpha: 1.0)
        


        setupToolbarButton()
        
    }
    
    
    func setupToolbarButton() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let composeNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        composeNoteButton.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        
        toolbarItems = [spacer, composeNoteButton]
        navigationController?.isToolbarHidden = false
    }
    
    
    
    @objc func composeNote() {
        //
    }
    
}

