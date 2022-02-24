//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentQuote: ForismaticQuote = ForismaticQuote(quoteText: "lolollllllll", quoteAuthor: "lollll", senderName: "", senderLink: "", quoteLink: "")
    
    @State var favourites: [ForismaticQuote] = []
    
    @State var currentQuoteAddedToFavourites: Bool = false
    
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
                    .stroke(Color.primary, lineWidth: 4))

                Image(systemName: "heart.circle")
                .resizable()
                .foregroundColor(currentQuoteAddedToFavourites == true ? .red : .secondary)
                .frame(width: 35, height: 35, alignment: .center)
                .onTapGesture {
                    if currentQuoteAddedToFavourites == false {
                        favourites.append(currentQuote)
                        currentQuoteAddedToFavourites == true
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
            
            
            List(favourites, id: \.self）{ currentFavourite in
                Text(currentFavourite.quoteText)
            }
            
            Spacer()
                        
        }
        // When the app opens, get a new joke from the web service
        .task {
            await loadNewQuote()
            
        }
        .navigationTitle("Quotes")
        .padding()
    }
    
}

func loadNewQuote()async{
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
