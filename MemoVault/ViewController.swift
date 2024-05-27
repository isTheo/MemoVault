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

class ViewController: UITableViewController, NoteViewControllerDelegate {
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "NoteCell")
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: note.date, dateStyle: .short, timeStyle: .short)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteEditorVC = NoteViewController()
        noteEditorVC.note = notes[indexPath.row]
        noteEditorVC.noteIndex = indexPath.row
        noteEditorVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: noteEditorVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.notes.remove(at: indexPath.row)
            NoteManager.shared.saveNotes(self.notes)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
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
        noteEditorVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: noteEditorVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func loadNotes() {
        notes = NoteManager.shared.loadNotes()
        tableView.reloadData()
    }
    
    
    func didSaveNote(_ note: Note, at index: Int?) {
        if let index = index {
            notes[index] = note
        } else {
            notes.append(note)
        }
        NoteManager.shared.saveNotes(notes)
        tableView.reloadData()
    }
    
    
    
    
}


