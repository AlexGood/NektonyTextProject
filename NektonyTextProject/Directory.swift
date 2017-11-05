//
//  Directory.swift
//  NektonyTextProject
//
//  Created by Alexandr Kudlak on 11/1/17.
//  Copyright © 2017 Alexandr Kudlak. All rights reserved.
//

import AppKit

public struct Metadata: CustomDebugStringConvertible, Equatable {
    
    let name: String
    let date: String
    let size: Int64
    let icon: NSImage
    let color: NSColor
    let isFolder: Bool
    let url: URL
    
    init(fileURL: URL, name: String, date: String, size: Int64, icon: NSImage, isFolder: Bool, color: NSColor ) {
        self.name = name
        self.date = date
        self.size = size
        self.icon = icon
        self.color = color
        self.isFolder = isFolder
        self.url = fileURL
    }
    
    public var debugDescription: String {
        return name + " " + "Folder: \(isFolder)" + " Size: \(size)"
    }
    
}

// MARK:  Metadata  Equatable

public func ==(lhs: Metadata, rhs: Metadata) -> Bool {
    return (lhs.url == rhs.url)
}


public struct Directory  {
    
    fileprivate var files: [Metadata] = []
    let url: URL
    
    public enum FileOrder: String {
        case Name
        case Date
        case Size
    }
    
    public init(folderURL: URL) {
        url = folderURL
        let requiredAttributes = [URLResourceKey.localizedNameKey, URLResourceKey.effectiveIconKey,
                                  URLResourceKey.typeIdentifierKey, URLResourceKey.contentModificationDateKey,
                                  URLResourceKey.fileSizeKey, URLResourceKey.isDirectoryKey,
                                  URLResourceKey.isPackageKey]
        if let enumerator = FileManager.default.enumerator(at: folderURL,
                                                           includingPropertiesForKeys: requiredAttributes,
                                                           options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants],
                                                           errorHandler: nil) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMMM-YYYY HH:mm"
            
            while let url = enumerator.nextObject() as? URL {
                do {
                    let properties = try url.resourceValues(forKeys: Set(requiredAttributes))
                    files.append(Metadata(fileURL: url,
                                          name: properties.localizedName ?? "",
                                          date: dateFormatter.string(from: properties.contentModificationDate ?? Date.distantPast),
                                          size: Int64(properties.fileSize ?? 0),
                                          icon: properties.effectiveIcon as? NSImage  ?? NSImage(),
                                          isFolder: properties.isDirectory ?? false,
                                          color: NSColor()))
                }
                catch {
                    print("Error reading file attributes")
                }
            }
        }
    }
    
    func getFiles() -> [Metadata] {
        return self.files
    }
}

