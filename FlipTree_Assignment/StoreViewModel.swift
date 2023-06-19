//
//  StoreViewModel.swift
//  FlipTree_Assignment
//
//  Created by HD-045 on 07/05/23.
//

import Foundation
import CoreData

class StoreViewModel: ObservableObject {
    
    @Published var storeElements: [StoreElements] = []
    @Published var errorMessage: String?
 
    // Load data from the API
    func loadData(context: NSManagedObjectContext) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.errorMessage = "Invalid response"
                return
            }
            
            guard let data = data else {
                self.errorMessage = "No data"
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let storeData = try decoder.decode([StoreElements].self, from: data)
                DispatchQueue.main.async {
                    self.storeElements = storeData
                    //
                    self.loadStoreData(storeData: storeData, context: context)
                }
            } catch let error {
                self.errorMessage = "Error decoding JSON: \(error.localizedDescription)"
            }
        }.resume()
    }
    

    // Fetch the image from the URL and save it to the corresponding StoreData instance
     func fetchImage(image:String,context:NSManagedObjectContext,id: Int64) {
         
         let fetchRequest: NSFetchRequest<StoreData> = StoreData.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
         
         guard let imageUrl = URL(string: image) else {
             return
         }
         
         let task = URLSession.shared.dataTask(with: imageUrl) {  data, response, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let results = try context.fetch(fetchRequest)
                 if let storeData = results.first {
                     // Update the `imageData` property of the `StoreData` instance
                     storeData.imageData = data
                     // Update the `imageData` property of the corresponding `StoreElements` instance
                     if let index = self.storeElements.firstIndex(where: { $0.id == Int(id) }) {
                         DispatchQueue.main.async {
                             self.storeElements[index].imageData = data
                         }
                     }
                 } else {
                     // No `StoreData` instance found with the given `id`
                    print("no coredata fetched for saving image data")
                }
            } catch let error {
                // Handle fetch error
                print("Fetch error: \(error)")
            }
            self.saveData(context: context)
        }
        task.resume()
    }
    
    
    
    // Create new StoreData entities and save them to Core Data
    func loadStoreData(storeData: [StoreElements], context: NSManagedObjectContext) {
        for (index, item) in storeData.enumerated() {
            let newStoreData = StoreData(context: context)
            newStoreData.id = Int64(index)
            newStoreData.title = item.title
            newStoreData.image = item.image
            newStoreData.productDescription = item.description
            newStoreData.price = item.price
            
            fetchImage(image: item.image, context: context, id: Int64(index))
        }
        saveData(context: context)
    }

    // Save changes made to Core Data context
    func saveData(context:NSManagedObjectContext){
        do{
            try context.save()
            print("Data saved")
        }
        catch let error {
            print(error.localizedDescription, "Error in saving data")
        }
    }
    
    
    

}
