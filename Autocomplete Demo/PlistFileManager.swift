//
//  PlistFileManager.swift
//  Autocomplete Demo
//
//  Created by Pawan kumar on 19/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit
import Foundation

class PlistFileManager: NSObject {
    var filePath: String = ""
    
    func getDocsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! String
        return documentsDir
    }
    
    func createPlistFile(fileName: String) {
        filePath = self.getDocsDir() //.stringByAppendingPathComponent(fileName)
        filePath.append(fileName)
        print("File Path:\n\(filePath)")
        let manager = FileManager.default
        
        if (!manager.fileExists(atPath: filePath)) {
            var taskArray = NSArray()
            taskArray.write(toFile: filePath, atomically: true)
        }
    }
    
    func fetchData(fileName: String) -> [String] {
        filePath = self.getDocsDir() //.stringByAppendingPathComponent(fileName)
        filePath.append(fileName)
        let plistData = NSArray(contentsOfFile: filePath) as! [(String)]
        return plistData
    }
    
    func saveData(fileName: String, tasks: NSArray) -> Bool {
        filePath = self.getDocsDir() //.stringByAppendingPathComponent(fileName)
        filePath.append(fileName)
        var success = tasks.write(toFile: filePath, atomically: true)
        
        if success {
            success = true
        }
        
        return success
    }
}
