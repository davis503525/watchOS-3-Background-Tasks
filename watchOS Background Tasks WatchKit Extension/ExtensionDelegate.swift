//
//  ExtensionDelegate.swift
//  watchOS Background Tasks WatchKit Extension
//
//  Created by Davis Allie on 26/08/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate, URLSessionTaskDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        // Example scheduling of background task an hour in the future
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 60 * 60), userInfo: nil) { (error: Error?) in
            if let error = error {
                print("Error occured while scheduling background refresh: \(error.localizedDescription)")
            }
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                beginDownloadTask()
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }

    func beginDownloadTask() {
        let config = URLSessionConfiguration.background(withIdentifier: "exampleSessionIdentifier")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: URL(string: "http://www.example.com/data")!)
        task.resume()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Session did complete")
    }
}
