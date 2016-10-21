//
//  NotesViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var progressContainer: UIView!
    var progressViews = [UIView]()
    
    var patient: String!
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = [
            Note(patient: patient, date: Date(), transcription: "Alice id doing fine. The pain meds are still doing their work"),
            Note(patient: patient, date: Date(), transcription: "Received 100ml of dilaudid")
        ]
        
        setupProgressViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = patient
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NotesViewController.requestedNewNote))
    }
    
    func requestedNewNote() {
        let noteCompositionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteCompositionViewController") as! NoteCompositionViewController
        noteCompositionViewController.delegate = self
        noteCompositionViewController.patient = patient
        present(noteCompositionViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notesViewController = segue.destination as? NoteViewController else {
            return
        }
        let selectedIndexPath = notesTableView.indexPathForSelectedRow!
        notesViewController.note = notes[selectedIndexPath.row]
        notesViewController.delegate = self
    }
    
    func setupProgressViews() {
        let numberOfViews = 7
        let incrementWidth = UIScreen.main.bounds.width / CGFloat(numberOfViews)
        let viewHeight: CGFloat = 50
        let viewSize = CGSize(width: incrementWidth, height: viewHeight)
        for i in 0..<numberOfViews {
            let origin = CGPoint(x: CGFloat(i) * incrementWidth, y: 0)
            let view = UIView(frame: CGRect(origin: origin, size: viewSize))
            view.tag = i
            progressContainer.addSubview(view)
            view.backgroundColor = UIColor.green
            progressViews.append(view)
        }
    }
    
    func updateProgressbar() {
        let portion = CGFloat(notes.count) / 7
        let mixedColor = blendColor(color1: UIColor.green, withColor: UIColor.red, portion: portion)
        for view in progressViews {
            view.backgroundColor = mixedColor
            if view.tag < notes.count {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    func blendColor(color1: UIColor, withColor color2: UIColor, portion: CGFloat) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2:CGFloat = 0
        var g2:CGFloat = 0
        var b2:CGFloat = 0
        var a2:CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: r1 * portion +  r2 * (1 - portion),
                       green: g1 * portion + g2 * (1 - portion),
                       blue: b1 * portion + b2 * (1 - portion),
                       alpha: max(a1, a2))
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
        updateProgressbar()
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

extension NotesViewController: NoteEditorDelegate {
    
    func didEditNote(newNote: Note) {
        let iteratingNotes = notes
        
        for (index, note) in iteratingNotes.enumerated() {
            if note.date == newNote.date {
                notes[index] = newNote
                notesTableView.reloadData()
                return
            }
        }
    }
    
}
