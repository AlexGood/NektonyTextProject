//
//  MainViewController.swift
//  NektonyTextProject
//
//  Created by Alexandr Kudlak on 11/1/17.
//  Copyright © 2017 Alexandr Kudlak. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    var files = [Metadata]()
    var directory: Directory?
    var link = URL(string:"")
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true
    let sizeFormatter = ByteCountFormatter()
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadFileList() {
        files = (directory?.getFiles())!
        
        tableView.reloadData()
    }
    
    @IBAction func chooseFolder(_ sender: NSButton) {
        let openPanel = NSOpenPanel();
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        
        let i = openPanel.runModal()
        if(i == NSApplication.ModalResponse.OK){
            self.directory = Directory(folderURL: openPanel.url!)
            self.link = openPanel.url!
            reloadFileList()
        }
    }
}

