
//
// Persistence.swift
// FlipTree_Assignment
//
// Created by HD-045 on 07/05/23.
//

import CoreData
import Foundation

// DataController class to manage core data stack and fetch data
class DataController: ObservableObject{

let container = NSPersistentContainer(name: "FlipTree_Assignment") // create an instance of NSPersistentContainer

//@Published var loadedStoreData: [StoreData] = [] // store fetched data

// initializer to setup core data stack and fetch data
init(){
    container.loadPersistentStores { description, err in
        if let err = err{
            print("bad data",err.localizedDescription)
        }
    }
//    fetchStoreData()
}

    /* fetch func not used since I am fetching the data in the view*/
//// function to fetch data
//func fetchStoreData(){
//    let request = NSFetchRequest<StoreData>(entityName: "StoreData") // create fetch request for StoreData entity
//    do {
//        loadedStoreData = try container.viewContext.fetch(request) // execute fetch request and store the result
//    }
//    catch{
//        print(error,"error fetch")
//    }
//}
    
    
}
