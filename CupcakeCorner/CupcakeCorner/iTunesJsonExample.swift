//
//  iTunesJsonExample.swift
//  CupcakeCorner
//
//  Created by roblack on 11/11/19.
//  Copyright © 2019 roblack. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct iTunesJsonExample: View {
        @State var results = [Result]()

    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                }
            }
            print("Fetch Failed \(error?.localizedDescription  ?? "Unknown Error")")
        }.resume()
    }
}

struct iTunesJsonExample_Previews: PreviewProvider {
    static var previews: some View {
        iTunesJsonExample()
    }
}
