//
//  LogFileManager.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

class LogFileManager : NSObject{
    
    //Shared Instance class
    static let sharedInstance = LogFileManager()
    
    override init() {
        super.init()
        //Set the name of the log files
        Log.logger.name = "Logs" //default is "logfile"
        
        //Set the max size of each log file. Value is in KB
        Log.logger.maxFileSize = 10240 //default is 1024
        
        //Set the max number of logs files that will be kept
        Log.logger.maxFileCount = 50 //default is 4
        
        //Set the directory in which the logs files will be written
        Log.logger.directory = AWSS3Manager.getDocumentsDirectory() //default is the standard logging directory for each platform.
        
        //Set whether or not writing to the log also prints to the console
        Log.logger.printToConsole = false //default is true
    }
    
    func writeDataInLogFile(logData: String){
        let saperator = "\n============================================================================================\n"
        logw("\(saperator)\(logData)\(saperator)")
    }
}
