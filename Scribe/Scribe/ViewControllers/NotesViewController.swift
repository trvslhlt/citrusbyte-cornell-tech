//
//  NotesViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var recordControl: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var patient: String!
    var notes: [Note] = [
        Note(date: Date(), transcription: "Alice id doing fine. The pain meds are still doing their work"),
        Note(date: Date(), transcription: "Received 100ml of dilaudid")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = patient
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NotesViewController.requestedNewNote))
    }
    
    func requestedNewNote() {
        let noteCompositionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteCompositionViewController") as! NoteCompositionViewController
        noteCompositionViewController.delegate = self
        present(noteCompositionViewController, animated: true, completion: nil)
    }

}

extension NotesViewController: NoteComposerDelegate {
    
    func didComposeNewNote(note: Note) {
        notes.insert(note, at: 0)
        notesTableView.reloadData()
    }
    
}


extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        let time = note.shortTimeFormat()
        let transcription = note.transcription
        cell.textLabel?.text = "\(time): \(transcription)"
        return cell
    }
    
}

