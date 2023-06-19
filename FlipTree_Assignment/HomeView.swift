
// This view displays a collection of movies
// loaded from Core Data, or a default list of movies
// if there is no data in the Core Data store.

import SwiftUI
import CoreData

struct MovieView: View {
    // The managed object context used to load data
    @Environment(\.managedObjectContext) var context

    // The view model that manages the store data
    @StateObject var storeViewModel = StoreViewModel()

    // The fetched results of the StoreData entity
    @FetchRequest(sortDescriptors: []) var storeData: FetchedResults<StoreData>

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                    // If there is no data in the store, use the default list
                    if storeData.isEmpty {
                        ForEach(storeViewModel.storeElements, id: \.id) { item in
                            NavigationLink(destination: MovieDetailView(imageData: item.imageData, title: item.title)) {
                                MovieTile(imageData: item.imageData, title: item.title)
                            }
                        }
                    }
                    // Otherwise, use the data from the store
                    else {
                        ForEach(storeData, id: \.id) { item in
                            NavigationLink(destination: MovieDetailView(imageData: item.imageData, title: item.title)) {
                                MovieTile(imageData: item.imageData, title: item.title)
                            }
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Store")
        }
        // When the view appears, load data if the store is empty
        .onAppear {
            if storeData.isEmpty {
                storeViewModel.loadData(context: context)
            }
        }
    }
}


// This view displays a single movie tile
struct MovieTile: View {
    let imageData: Data?
    let title: String?

    @State var isLoading = true

    var body: some View {
        VStack {
            // Display the movie image or a placeholder if there is none
            if let imageData = imageData {
                Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .onAppear {
                        // Set `isLoading` to false when the image is loaded
                        isLoading = false
                    }
            } else {
                ProgressView()
                    .frame(height: 200)
            }

            // Display the movie title or a default title if there is none
            Text(title ?? "Unknown Title")
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(8)
    }
}

// This view displays detailed information about a movie
struct MovieDetailView: View {
    let imageData: Data?
    let title: String?

    var body: some View {
        VStack {
            // Display the movie image or a placeholder if there is none
            Image(uiImage: (UIImage(data: imageData ?? Data()) ?? UIImage(systemName: "photo"))!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        
            // Display the movie title or a default title if there is none
            Text(title ?? "Unknown Title")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Spacer()
        }
        .navigationTitle(title ?? "Unknown Title")
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
            .environmentObject(DataController())
    }
}
