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
    var notes: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
/* dovrebbe risultare in una barra traslucida...
         navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
*/
        
        
        setupToolbarButton()
        loadNotes()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") ?? UITableViewCell(style: .default, reuseIdentifier: "Notecell")
        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteEditorVC = NoteViewController()
        noteEditorVC.noteText = notes[indexPath.row]
          let navigationController = UINavigationController(rootViewController: noteEditorVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    //slide per cancellare una nota
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Rimuovi la nota dall'array
            self.notes.remove(at: indexPath.row)
            
            //aggiorna UserDefaults
            UserDefaults.standard.set(self.notes, forKey: "notes")
            
            //rimuove la riga dalla tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        //aggiunge l'icona classica del cestino
        deleteAction.image = UIImage(systemName: "trash")
        
        //crea la configurazione delle azioni di swipe
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    
    func setupToolbarButton() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let composeNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        composeNoteButton.tintColor = UIColor(red: 236/255, green: 180/255, blue: 130/255, alpha: 1.0)
        
        toolbarItems = [spacer, composeNoteButton]
        navigationController?.isToolbarHidden = false
    }
    
    
    
    @objc func composeNote() {
        let noteEditorVC = NoteViewController()
        let navigationController = UINavigationController(rootViewController: noteEditorVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        print("View controller appeared")
    }
    
    func loadNotes() {
        notes = UserDefaults.standard.array(forKey: "notes") as? [String] ?? []
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
}

