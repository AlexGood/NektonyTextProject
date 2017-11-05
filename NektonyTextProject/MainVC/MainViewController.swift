//
//  MainViewController.swift
//  NektonyTextProject
//
//  Created by Alexandr Kudlak on 11/1/17.
//  Copyright © 2017 Alexandr Kudlak. All rights reserved.
//

import Cocoa
import FilesProvider

class MainViewController: NSViewController {
    
    var files = [Metadata]()
    var directory: Directory?
    var link = URL(string:"")
    
    let sizeFormatter = ByteCountFormatter()
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func reloadFileList() {
        if let files = directory?.getFiles() {
            self.files = files
            tableView.reloadData()
        }
    }
    
    @IBAction func chooseFolder(_ sender: NSButton) {
        let openPanel = NSOpenPanel();
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        
        let i = openPanel.runModal()
        if(i == NSApplication.ModalResponse.OK){
            if let openPanelUrl = openPanel.url{
                
                let documentsProvider = LocalFileProvider(baseURL: openPanelUrl)
                
                documentsProvider.registerNotifcation(path: "/") {
                    self.updateList(openPanelUrl: openPanelUrl)
                }
                
                self.updateList(openPanelUrl: openPanelUrl)
            }
        }
    }
    
    func updateList(openPanelUrl: URL){
        self.directory = Directory(folderURL: openPanelUrl)
        self.link = openPanelUrl
        reloadFileList()
    }
}

