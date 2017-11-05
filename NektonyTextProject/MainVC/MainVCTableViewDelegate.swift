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
        
        if 0 <= row && row < self.files.count{
            let file = self.files[row]
            // @Constantine: Вообщем по методу
            //      5. Изменение содержимого ячеек происходит в этом методе. В случае сложного дизайна - метод разрастется.
            //         Я предпочитаю создавать для каждой ячейки класс, который отвечает за заполнение ее содержимым.
            
            if tableColumn == tableView.tableColumns[0] {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.nameCell), owner: nil) as? NSTableCellView
                
                cell?.textField?.stringValue = file.name
                cell?.imageView?.image = file.icon
                
                return cell
            } else if tableColumn == tableView.tableColumns[1] {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.hashCell), owner: nil) as? NSTableCellView
                // @Constantine: Эта ячейка не очищается после переиспользования.
                //               В итоге до подсчета хеша отображается хеш какого-то левого файла
                
                // @Constantine: Насколько я понял хеш нигде не сохраняется.
                //               Обидно что его нужно считать снова и снова учитывая что это долгая операция.
                
                // @Constantine: Этот метод делегата должен быть максимально быстрым
                //               Поднятие большого файла в память - не быстро
                //               Представим что файл занимает 25 GB - что нам скажет система, если мы займем столько памяти?
                let data = NSData(contentsOfFile: String(describing: file.url.path)) as Data?
                if data != nil{
                    // @Constantine: Очередь никак не контролируется. Если мы уже проскроллили дальше и хеш уже не нужен - он всеравно посчитается.
                    DispatchQueue.global(qos: .background).async {
                        if let hash = data?.md5().base64EncodedString(){
                            OperationQueue.main.addOperation {
                                // @Constantine: Здесь логическая ошибка. Когда хеш посчитается - то ячейка уже может отобрать данные другого файла.
                                //               Это заметно если на большом поличестве файлов по скроллить и потом у одной ячейки будет задаваться
                                // постепенно разные хеши.
                                cell?.textField?.stringValue = hash
                            }
                        }
                    }
                } else {
                    cell?.textField?.stringValue = "--"
                }
                
                return cell
            } else if tableColumn == tableView.tableColumns[2] {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.sizeCell), owner: nil) as? NSTableCellView
                
                cell?.textField?.stringValue = file.isFolder ? "--" : sizeFormatter.string(fromByteCount: file.size)
                
                return cell
            }else if tableColumn == tableView.tableColumns[3] {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: CellIdentifiers.modifDataCell), owner: nil) as? NSTableCellView
                
                cell?.textField?.stringValue = file.date
                
                return cell
            }
        }
        
        return nil
    }
}

