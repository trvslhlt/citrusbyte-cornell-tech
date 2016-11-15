//
//  ViewController.swift
//  Scribe
//
//  Created by trvslhlt on 10/20/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController {

    let patients = ["Betty Chou", "Atul Soni", "Nathaniel Foster", "Marisa Wittgenstein", "Holden Smith"]
    
    @IBOutlet weak var patientsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Patients"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notesViewController = segue.destination as? NotesViewController else {
            return
        }
        let selectedIndexPath = patientsTable.indexPathForSelectedRow!
        notesViewController.patient = patients[selectedIndexPath.row]
    }
    
}

extension PatientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = patients[indexPath.row]
        return cell
    }
    
}

