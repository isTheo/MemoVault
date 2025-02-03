//
//  ViewController.swift
//  MemoVault
//
//  Created by Matteo Orru on 18/05/24.
//



import UIKit

class ViewController: UITableViewController, NoteViewControllerDelegate, UISearchResultsUpdating {
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupToolbarButton()
        setupSearchController()
        loadNotes()
    }
    
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "NoteCell")
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: note.date, dateStyle: .short, timeStyle: .short)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         
         let noteEditorVC = NoteViewController()
         let selectedNote = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
         noteEditorVC.note = selectedNote
         noteEditorVC.noteIndex = isFiltering ? notes.firstIndex(where: { $0.text == selectedNote.text }) : indexPath.row
         noteEditorVC.delegate = self
         
         let navigationController = UINavigationController(rootViewController: noteEditorVC)
         navigationController.modalPresentationStyle = .fullScreen
         present(navigationController, animated: true, completion: nil)
     }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let noteToDelete = self.isFiltering ? self.filteredNotes[indexPath.row] : self.notes[indexPath.row]
            if let index = self.notes.firstIndex(where: { $0.text == noteToDelete.text }) {
                self.notes.remove(at: index)
                NoteManager.shared.saveNotes(self.notes)
                
                if self.isFiltering {
                    self.filteredNotes.remove(at: indexPath.row)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    
    // MARK: - Search Controller
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { note in
            return note.text.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
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
        
        if isFiltering {
            filterContentForSearchText(searchController.searchBar.text ?? "")
        }
        
        tableView.reloadData()
    }
    
    
    
    
}




