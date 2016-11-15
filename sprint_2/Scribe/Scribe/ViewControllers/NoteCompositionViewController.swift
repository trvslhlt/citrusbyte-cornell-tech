//
//  NoteCompositionViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

protocol NoteComposerDelegate: class {
    func didComposeNewNote(note: Note)
}


class NoteCompositionViewController: UIViewController {

    @IBOutlet weak var timeIndication: UILabel!
    @IBOutlet weak var translationPreview: UITextView!
    @IBOutlet weak var recordingControl: UIButton!
    @IBOutlet weak var cancelControl: UIButton!
    @IBOutlet weak var submitControl: UIButton!
    
    var patient: String?
    let time = Date()
    weak var delegate: NoteComposerDelegate?
    var recordingInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        timeIndication.text = dateFormatter.string(from: time)
        translationPreview.text = ""
        configureForRecord()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NoteCompositionViewController.backTapped))
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    
    @IBAction func recordControlChangeRequested(_ sender: AnyObject) {
        if isConfiguredForRecord() {
            if SpeechToTextTranslator.sharedInstance.isAuthorized {
                recordingInProgress = true
                SpeechToTextTranslator.sharedInstance.startRecording(updatedTranscription: { transcription in
                    self.translationPreview.text = transcription
                })
                configureForStop()
            } else {
                SpeechToTextTranslator.sharedInstance.requestAuthorization(completion: { success in
                    print("Authorized? \(success)")
                })
            }
        } else {
            recordingInProgress = false
            SpeechToTextTranslator.sharedInstance.stopRecording()
            configureForRecord()
        }
    }
    
    func isConfiguredForRecord() -> Bool {
        return recordingControl.titleLabel?.text ?? "" == "Record"
    }
    
    func configureForStop() {
        recordingControl.setTitle("Stop", for: .normal)
        recordingControl.alpha = 1
    }

    func configureForRecord() {
        recordingControl.setTitle("Record", for: .normal)
        recordingControl.alpha = 0.8
    }
    
    func backTapped() {
        if recordingInProgress {
            let alert = UIAlertController(title: "Recording in Progress", message: "Please stop the recording before exiting", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        } else {
            submitNote()
        }
    }
    
    @IBAction func submitRequested(_ sender: AnyObject) {
        if recordingInProgress {
            return
        }
        submitNote()
    }

    func submitNote() {
        guard let transcription = translationPreview.text else {
            return
        }
        guard let patient = patient else {
            return
        }
        let note = Note(patient: patient, date: self.time, transcription: transcription)
        delegate?.didComposeNewNote(note: note)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissRequested(_ sender: AnyObject) {
        if recordingInProgress {
            return
        }
        dismiss(animated: true, completion: nil)
    }

}
