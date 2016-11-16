//
//  PatientListViewController.swift
//  Scribe
//
//  Created by trvslhlt on 11/15/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import UIKit
import Atlas

class PatientListViewController: ATLConversationListViewController {

    var conversationTitles: [String] {
        return ["L. Patient 1", "L Patient 2"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

}

extension PatientListViewController: ATLConversationListViewControllerDataSource {
    
    func conversationListViewController(_ conversationListViewController: ATLConversationListViewController, titleFor conversation: LYRConversation) -> String {
        return conversationTitles[0]
    }
    
}

extension PatientListViewController: ATLConversationListViewControllerDelegate {
    
    
    
}

