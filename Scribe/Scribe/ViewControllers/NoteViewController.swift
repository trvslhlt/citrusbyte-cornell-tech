//
//  NoteViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

protocol NoteEditorDelegate: class {
    func didEditNote(newNote: Note)
}

class NoteViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var transcriptionEditor: UITextView!
    var note: Note?
    var newNote: Note?
    weak var delegate: NoteEditorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NoteViewController.backTapped))
        self.navigationItem.leftBarButtonItem = newBackButton;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
            transcriptionEditor.text = note.transcription
            timeLabel.text = note.longTimeFormat()
        }
    }
    
    func backTapped() {
        guard let newNote = newNote else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        delegate?.didEditNote(newNote: newNote)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func createNewNote() {
        newNote = Note(patient: note!.patient, date: note!.date, transcription: transcriptionEditor.text)
    }
    
}

extension NoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            createNewNote()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


