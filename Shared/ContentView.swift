//
//  ContentView.swift
//  Shared
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI
import SwiftUIRefresh

struct CountryResponse: Codable {
    var Countries: [Result]
}

struct GlobalResponse: Codable {
    var Global: Result
}

struct IndiaResponse: Codable {
    var India: [IndiaStates]
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

struct District: Codable {
    var name: String
    var confirmed: Int
}

struct IndiaStates: Codable {
    var state: String
    var active: Int
    var confirmed: Int
    var recovered: Int
    var deaths: Int
    var aChanges: Int
    var cChanges: Int
    var rChanges: Int
    var dChanges: Int
    var districtData: [District]
    
}

struct ContentView: View {
    @State var Countries = [Result]()
    @State var Global : Result
    @State var India = [IndiaStates]()
    @State private var isShowing = false
    @State var IndiaDetails : Result
    
    func loadCountriesData() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CountryResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.Countries = decodedResponse.Countries.sorted{
                            $0.TotalConfirmed > $1.TotalConfirmed
                        }
                        IndiaDetails = decodedResponse.Countries.filter{$0.Country == "India"}.first!
                    }
                    // everything is good, so we can exit
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

    }
    
    func loadGlobalData() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(GlobalResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.Global = decodedResponse.Global
                    }
                    // everything is good, so we can exit
                    
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

    }
    
    func loadStatesData() {
        guard let url = URL(string: "https://api.covidindiatracker.com/state_data.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([IndiaStates].self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.India = decodedResponse.sorted{
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
        
        TabView {
            NavigationView{
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Confirmed").font(.largeTitle).fontWeight(.bold)
                                Text("↑\(Global.NewConfirmed)")
                            }
                            Text("\(Global.TotalConfirmed)").font(.title)
                        }
                        Spacer()
                    }
                    .padding(.vertical).background(Color.orange)
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Active").font(.largeTitle).fontWeight(.bold)
                                Text("↑\(Global.NewConfirmed - Global.NewRecovered)")
                            }
                            Text("\(Global.TotalConfirmed - Global.TotalDeaths - Global.TotalRecovered)").font(.title)
                        }
                        Spacer()
                    }
                    .padding(.vertical).background(Color.blue)
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Recovered").font(.largeTitle).fontWeight(.bold)
                                Text("↑\(Global.NewRecovered)")
                            }
                            Global.TotalRecovered == 0 ? Text(" N/A").font(.title) : Text(" \(Global.TotalRecovered)").font(.title)
                            
                        }
                        Spacer()
                    }.padding(.vertical).background(Color.green)
                    HStack{
                        Spacer()
                        VStack {
                            Text("Recovery Rate:" ).fontWeight(.bold).font(.title)
                            Text("\((Double(Global.TotalRecovered) / Double(Global.TotalConfirmed) * 100), specifier: "%.2f")%").font(.title2)
                        }
                        Spacer()
                    }.padding(.vertical).background(Color.green.opacity(0.9))
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Deceased").font(.largeTitle).fontWeight(.bold)
                                Text("↑\(Global.NewDeaths)")
                            }
                            Text("\(Global.TotalDeaths)").font(.title)
                        }
                        Spacer()
                    }.padding(.vertical).background(Color.red)
                    HStack{
                        Spacer()
                        VStack {
                            Text("Fatality Rate:" ).fontWeight(.bold).font(.title)
                            Text("\((Double(Global.TotalDeaths) / Double(Global.TotalConfirmed) * 100), specifier: "%.2f")%").font(.title2)
                        }
                        Spacer()
                    }.padding(.vertical).background(Color.red.opacity(0.9))
                }
                .onAppear(perform: loadGlobalData)
                .navigationTitle("🌍 Global Summary")
            }.tabItem {
                    Image(systemName: "globe")
                    Text("Global Summary")
                }
            
            
            NavigationView{
                    List{
                    Section(header: Text("Overview")){
                        HStack {
                            Text("Confirmed: \(IndiaDetails.TotalConfirmed)")
                            Text("↑ \(IndiaDetails.NewConfirmed)").foregroundColor(.orange).fontWeight(.semibold)
                        }
                        HStack {
                            Text("Active: \(IndiaDetails.TotalConfirmed - IndiaDetails.TotalRecovered)")
                            Text("↑ \(IndiaDetails.NewConfirmed - IndiaDetails.NewRecovered)").foregroundColor(.blue).fontWeight(.semibold)
                        }
                        HStack {
                            Text("Recovered: \(IndiaDetails.TotalRecovered)")
                            Text("↑ \(IndiaDetails.NewRecovered)").foregroundColor(.green).fontWeight(.semibold)
                        }
                        HStack {
                            Text("Deceased: \(IndiaDetails.TotalDeaths)")
                            Text("↑ \(IndiaDetails.NewDeaths)").foregroundColor(.red).fontWeight(.semibold)
                        }
                    }
                        Section(header: Text("Statewise distribution")){
                        ForEach(India, id: \.state){ item in
                        StateCell(state: item)}
                    }
                    }.listStyle(InsetGroupedListStyle())
                    .navigationTitle("🇮🇳 India")
                }.onAppear(perform: loadStatesData)
                .tabItem {
                    Image(systemName: "mappin")
                    Text("🇮🇳 India")
                }
            
            NavigationView{
                List(Countries, id: \.Country) { item in
                    CountryCell(country: item)
                }.onAppear(perform: loadCountriesData).pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                        }
                }.navigationTitle("🦠 All Countries")
            }
            .tabItem {
                Image(systemName: "map")
                Text("Countries")
            }
            
        }
        .font(.headline)
    }
}


let testDataIndia = [IndiaStates(state: "Sikkim",active: 235,confirmed: 343,recovered: 108,deaths: 0,aChanges: 0,cChanges: 0,rChanges: 0,dChanges: 0, districtData: [District(name: "Unknown",confirmed: 0),]),]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(Global: testData[1], India: testDataIndia, IndiaDetails: testData[0])
            .preferredColorScheme(.dark)
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

struct StateCell: View {
    var state : IndiaStates
    var body: some View {
        NavigationLink(destination: StateDetail(districts: state.districtData, state: state))
        {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(state.state).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    
                    Text("🟡 \(state.confirmed)").font(.footnote)
                    state.recovered == 0 ? Text("🟢 N/A").font(.footnote) : Text("🟢 \(state.recovered)").font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                    Text("🔴 \(state.deaths)").font(.footnote)
                    
                    
                }
                .padding(.vertical, 5.0)
                
                
            }
        }
    }
}

struct StateDetail: View{
    var districts : [District]
    var state: IndiaStates
    
    var body: some View{
        List{
            Section(header: Text("Overview")){
                HStack {
                    Text("Confirmed: \(state.confirmed)")
                    Text("↑ \(state.cChanges)").foregroundColor(.orange).fontWeight(.semibold)
                }
                HStack {
                    Text("Active: \(state.confirmed - state.recovered)")
                    Text("↑ \(state.cChanges - state.rChanges)").foregroundColor(.blue).fontWeight(.semibold)
                }
                HStack {
                    Text("Recovered: \(state.recovered)")
                    Text("↑ \(state.rChanges)").foregroundColor(.green).fontWeight(.semibold)
                }
                HStack {
                    Text("Deceased: \(state.deaths)")
                    Text("↑ \(state.dChanges)").foregroundColor(.red).fontWeight(.semibold)
                }
            }
            
            Section(header: HStack {
                Text("District").fontWeight(.regular)
                Spacer()
                Text("Confirmed Cases").fontWeight(.semibold)
            }){
            ForEach(districts, id: \.self.name){ district in
                HStack {
                    Text("\(district.name)")
                    Spacer()
                    Text("\(district.confirmed)").fontWeight(.bold)
                }
            }.navigationTitle("\(state.state)")
            }}.listStyle(InsetGroupedListStyle())
    }
}
