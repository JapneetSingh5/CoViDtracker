//
//  ContentView.swift
//  Shared
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var country_region : String
    var confirmed: Int
    var recovered: Int
    var deaths: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    func loadData() {
        guard let url = URL(string: "https://2019ncov.asia/api/country_region") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.results.sorted{
                            $0.confirmed > $1.confirmed
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

    }
    
    var body: some View {
        NavigationView{
            List(results, id: \.country_region) { item in
                CountryCell(country: item).navigationTitle("🦠 CoViDtracker")
                }.onAppear(perform: loadData)
            }
        
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}

struct CountryCell: View {
    var country : Result
    var body: some View {
        NavigationLink(destination: CountryDetail(country: country))
        {
            Text("🏴").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(country.country_region).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    
                    Text("🟡 \(country.confirmed)").font(.footnote)
                    country.recovered == 0 ? Text("🟢 N/A").font(.footnote) : Text("🟢 \(country.recovered)").font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                    Text("🔴 \(country.deaths)").font(.footnote)
                    
                    
                }
                .padding(.vertical, 5.0)
                
                
            }
        }
    }
}
