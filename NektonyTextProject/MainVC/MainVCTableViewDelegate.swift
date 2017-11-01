//
//  MainVCTableViewDelegate.swift
//  NektonyTextProject
//
//  Created by Alexandr Kudlak on 11/1/17.
//  Copyright © 2017 Alexandr Kudlak. All rights reserved.
//

import Cocoa
import CryptoSwift

extension MainViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    fileprivate enum CellIdentifiers {
        static let nameCell = "nameCellId"
        static let hashCell = "hashCellId"
        static let sizeCell = "sizeCellId"
        static let modifDataCell = "modifDateCellId"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.files.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.nameCell), owner: nil) as? NSTableCellView
            
            cell?.textField?.stringValue = self.files[row].name
            cell?.imageView?.image = self.files[row].icon
            
            return cell
        } else if tableColumn == tableView.tableColumns[1] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.hashCell), owner: nil) as? NSTableCellView
            
            let view = NSView()
            view.frame.size.width = 1280
            view.frame.size.height = 800
            view.layer?.backgroundColor = .black
            cell?.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let data = NSData(contentsOfFile: String(describing: self.files[row].url.path)) as Data?
            if data != nil{
                DispatchQueue.global(qos: .background).async {
                    let hash = (data?.md5().base64EncodedString())!
                    OperationQueue.main.addOperation {
                        cell?.textField?.stringValue = hash
                    }
                }
            } else {
                cell?.textField?.stringValue = "--"
            }
            
            return cell
        } else if tableColumn == tableView.tableColumns[2] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.sizeCell), owner: nil) as? NSTableCellView
            
            cell?.textField?.stringValue = self.files[row].isFolder ? "--" : sizeFormatter.string(fromByteCount: self.files[row].size)
            
            return cell
        }else if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.modifDataCell), owner: nil) as? NSTableCellView
            
            cell?.textField?.stringValue = self.files[row].date
            
            return cell
        }
        return nil
    }
    
}
