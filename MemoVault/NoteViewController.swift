//
//  NoteViewController.swift
//  MemoVault
//
//  Created by Matteo Orru on 22/05/24.
//


import UIKit


protocol NoteViewControllerDelegate: AnyObject {
    func didSaveNote(_ note: Note, at index: Int?)
}


class NoteViewController: UIViewController {
    var note: Note?
    var noteIndex: Int?
    weak var delegate: NoteViewControllerDelegate?
    
    let textView = UITextView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .systemBackground
        
        if let note = note {
            textView.text = note.text
        }
        


    }
    
    

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
        }, completion: nil)
    }

    

    func setupUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.font = UIFont.systemFont(ofSize: 16)
        
        updateTextViewAppearance()
        
        textView.becomeFirstResponder()
                
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = doneButton
        

        let backButtonIcon = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
        let backButtonTitle = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(goBack))
        backButtonTitle.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        backButtonIcon.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)

        navigationItem.leftBarButtonItems = [backButtonIcon, backButtonTitle]

    }
    
    
    
    func updateTextViewAppearance() {
        textView.backgroundColor = .systemBackground
        textView.textColor = .label
    }

    
    
    @objc func done() {
        guard let noteText = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !noteText.isEmpty else {
            return
        }
        
        let note = Note(text: noteText, date: Date())
        delegate?.didSaveNote(note, at: noteIndex)
        
        dismiss(animated: true, completion: nil)
    }

    
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
}

