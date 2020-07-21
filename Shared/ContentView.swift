//
//  ContentView.swift
//  Shared
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI
import SwiftUIRefresh

struct Response: Codable {
    var Countries: [Result]
}

struct Result: Codable {
    var Country : String
    var TotalConfirmed: Int
    var TotalRecovered: Int
    var TotalDeaths: Int
    var NewConfirmed: Int
    var NewRecovered: Int
    var NewDeaths: Int
    var CountryCode: String
    var Flag: String{
        let base : UInt32 = 127397
        var s = ""
        for v in CountryCode.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}

struct ContentView: View {
    @State private var Countries = [Result]()
    @State private var isShowing = false
    
    func loadData() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else {
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
                        self.Countries = decodedResponse.Countries.sorted{
                            $0.TotalConfirmed > $1.TotalConfirmed
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
            List(Countries, id: \.Country) { item in
                CountryCell(country: item).navigationTitle("🦠 CoViDtracker")
            }.onAppear(perform: loadData).pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
            }
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
            Text(country.Flag).font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(country.Country).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    
                    Text("🟡 \(country.TotalConfirmed)").font(.footnote)
                    country.TotalRecovered == 0 ? Text("🟢 N/A").font(.footnote) : Text("🟢 \(country.TotalRecovered)").font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                    Text("🔴 \(country.TotalDeaths)").font(.footnote)
                    
                    
                }
                .padding(.vertical, 5.0)
                
                
            }
        }
    }
}
