//
//  FlipTree_AssignmentApp.swift
//  FlipTree_Assignment
//
//  Created by HD-045 on 07/05/23.
//

import SwiftUI

@main
struct FlipTree_AssignmentApp: App {
    
@StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            MovieView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                
        }
    }
}
