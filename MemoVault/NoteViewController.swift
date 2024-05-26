//
//  NoteViewController.swift
//  MemoVault
//
//  Created by Matteo Orru on 22/05/24.
//

import UIKit

class NoteViewController: UIViewController {
    
    let textView = UITextView()
    var noteText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
    
    
    func setupUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.font = UIFont.systemFont(ofSize: 16)
        
        textView.becomeFirstResponder()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
        
        let backButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        
        textView.text = noteText
        
    }
    
    
    @objc func done() {
        guard let noteText = textView.text, !noteText.isEmpty else {return}
        //recupera la nota salvata
        var notes = UserDefaults.standard.array(forKey: "notes") as? [String] ?? []
        
        notes.append(noteText)
        
        UserDefaults.standard.set(notes, forKey: "notes")
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
