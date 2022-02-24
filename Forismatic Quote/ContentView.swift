//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Stored properties
    @State var currentQuote: ForismaticQuote = ForismaticQuote(quoteText: "lolollllllll", quoteAuthor: "lollll", senderName: "", senderLink: "", quoteLink: "")
    
    @State var favourites: [ForismaticQuote] = []
    
    @State var currentQuoteAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            VStack{
                Text(currentQuote.quoteText)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding(30)
                    .minimumScaleFactor(0.5)
                
                
                
                
                HStack{
                    Spacer()
                    
                    Text("--\(currentQuote.quoteAuthor)")
                        .padding(10)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.primary, lineWidth: 4)
            )
            
            
            Image(systemName: "heart.circle")
                .resizable()
                .foregroundColor(currentQuoteAddedToFavourites == true ? .red : .secondary)
                .frame(width: 35, height: 35, alignment: .center)
                .onTapGesture {
                    if currentQuoteAddedToFavourites == false {
                        favourites.append(currentQuote)
                        currentQuoteAddedToFavourites = true
                    }
                }
            
            Button(action: {
                Task {
                    await loadNewQuote()
                }
            }, label: {
                Text("Another One!")
            })
                .buttonStyle(.bordered)
                .padding()
            
            HStack {
                Text("Favoutites")
                    .bold()
                
                Spacer()
            }
            
            List(favourites, id: \.self) { currentFavourite in
                Text(currentFavourite.quoteText)
            }
            
        }
        // When the app opens, get a new joke from the web service
        .task {
            await loadNewQuote()
            
            
            print("I tried to load a new quote")
            
            // Load the Favourites from the file saved on the device
            loadFavourites()
            
        }
        onChange(of: scenePhase){
            newPhase in
            
            if newPhase == .inactive{
                print("Inactive")
                
                } else if newPhase == .active{
                    print("Active")
                } else if newPhase == .background{
                    print("Background")
                    
                    persistFavourites()
                }
            }
        .navigationTitle("Quotes")
        .padding()
        
    }
    
    // MARK: Functions
    func loadNewQuote() async {
        
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentQuote = try JSONDecoder().decode(ForismaticQuote.self, from: data)
            
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
    
    func persistFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(saveFavouritesLabel)
        print(filename)
        
        do {
           
            //create a JSON encoder object
            let encoder = JSONEncoder()
            
            //COnfigure the encoder to "pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of Favourites we've collect
            let data = try encoder.encode(favourites)
            
            //write the JSON to a file in the filename location we came up with earlier
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //see the data that was written
            print("Saved data to the Documents successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
        } catch  {
            print("Unable  to write list of favourites to the Documents directly.")
            print("======")
            print(error.localizedDescription)
        }
        
    }
    
    func loadFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(saveFavouritesLabel)
        print(filename)
        
        //Attempt to load the data
        do {
           
            //Load the raw data
            let data = try Data(contentsOf: filename)
            
            //see the data that was written
            print("Saved data to the Documents successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
            
            //Decode the JSON into the swift native data structure
            favourites = try JSONDecoder().decode([ForismaticQuote].self, from: data)
            
        } catch {
            //What went wrong?
            print("Could not load the data from the stored JSON file")
            print("======")
            print(error.localizedDescription)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
