//
//  NoteCompositionViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

class NoteCompositionViewController: UIViewController {

    @IBOutlet weak var timeIndication: UILabel!
    @IBOutlet weak var translationPreview: UITextView!
    @IBOutlet weak var recordingControl: UIButton!
    @IBOutlet weak var cancelControl: UIButton!
    @IBOutlet weak var submitControl: UIButton!
    
    let time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        timeIndication.text = dateFormatter.string(from: time)
        translationPreview.text = ""
    }
    
    
    @IBAction func recordControlChangeRequested(_ sender: AnyObject) {
        print("record")
    }
    
    
    @IBAction func submitRequested(_ sender: AnyObject) {
        print("submit")
    }
    
    @IBAction func dismissRequested(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
