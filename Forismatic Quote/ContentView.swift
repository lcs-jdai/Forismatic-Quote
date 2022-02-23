//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentQuote: ForismaticQuote = ForismaticQuote(quoteText: "lolollllllll", quoteAuthor: "lollll", senderName: "", senderLink: "", quoteLink: "")
    
    var body: some View {
        VStack {
            
            Text(currentQuote.quoteText)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding(30)
                    .minimumScaleFactor(0.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.primary, lineWidth: 4)
                    )
                    .padding(10)
            
            Text("--\(currentQuote.quoteAuthor)")
                    .padding(10)
           
                Image(systemName: "heart.circle")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 35, height: 35, alignment: .center)
            
            Button(action: {
                print("I've been pressed.")
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
            
            
            List {
                Text("Which side of the chicken has more feathers? The outside.")
                Text("Why did the Clydesdale give the pony a glass of water? Because he was a little horse!")
                Text("The great thing about stationery shops is they're always in the same place...")
            }
            
            Spacer()
                        
        }
        // When the app opens, get a new joke from the web service
        .task {
            
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
        .navigationTitle("Quotes")
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
