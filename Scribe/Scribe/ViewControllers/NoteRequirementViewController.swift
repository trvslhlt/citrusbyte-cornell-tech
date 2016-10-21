//
//  NoteRequirementViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/21/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

class NoteRequirementViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = "1. Pulse\n\n2. Respiration\n\n3. Temperature\n\n4. Blood pressure\n\n5. Mood and Affect\n\n6. Psycho-motor\n\n7. Speech"
    }
    
    @IBAction func dismissTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
