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
    @State var IndiaDetails: Result
    @State private var customTab: String = "Custom Name"
    @State private var enableCustom: Bool = false
    @State private var enableNews: Bool = true
    @State var customTabIcon: Int = 0
    @State var countryDetails: Bool = true
    @State var countryDetailsTop10: Bool = true
    @State var stateDetails: Bool = true
    
    var iconOptions = ["star.fill" , "star", "pc", "note", "note.text", "location.fill", "doc.fill", "doc.text.fill", "book.fill"]
    
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
                        self.Global.NewConfirmed = decodedResponse.Global.NewConfirmed
                        self.Global.NewRecovered = decodedResponse.Global.NewRecovered
                        self.Global.NewDeaths = decodedResponse.Global.NewConfirmed
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
            GlobalSummary(Global: Global)
            }
        .onAppear(perform: loadGlobalData)
        .tabItem {
                Image(systemName: "globe")
                Text("Global")
            }
        
            
            if enableNews {
                NavigationView{
                    ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                                ForEach(0..<9999){_ in
                                    VStack {
                                        HStack {
                                            Image(systemName: "newspaper")
                                                .font(.system(size: 30))
                                                .frame(width: 50, height: 50)
                                                .background(Color.black)
                                                .cornerRadius(10)
                                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                            Text("News article headline - can be pretty long too - or mega long as you like").font(.headline)
                                                .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                            Spacer()
                                        }
                                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.").padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                    }.background(Color.red).cornerRadius(10).padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).padding(.top, 5)
                                }
                            }
                    }.navigationTitle("📰 News Feed")
                }
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                }
            }
            .tabItem {
                Image(systemName: "newspaper.fill")
                Text("News")
            }
                
            }
            
            if enableCustom {
            VStack{
                Text("Hi, this is your \(customTab) tab")
            }
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                }
            }
            .tabItem {
                Image(systemName: iconOptions[customTabIcon])
                Text(customTab)
            }
                
            }
            
            
            NavigationView{
                    List{
                    Section(header: Text("Overview")){
                        HStack {
                            Text("CONFIRMED").foregroundColor(.orange).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("\(IndiaDetails.TotalConfirmed)")
                            Text("↑ \(IndiaDetails.NewConfirmed)").foregroundColor(.orange).fontWeight(.medium)
                        }
                        HStack {
                            Text("ACTIVE").foregroundColor(.blue).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("\(IndiaDetails.TotalConfirmed - IndiaDetails.TotalRecovered)")
                            Text("↑ \(IndiaDetails.NewConfirmed - IndiaDetails.NewRecovered)").foregroundColor(.blue).fontWeight(.medium)
                        }
                        HStack {
                            Text("RECOVERED").foregroundColor(.green).fontWeight(.bold)
                            Text("\(IndiaDetails.TotalRecovered)")
                            Text("↑ \(IndiaDetails.NewRecovered)").foregroundColor(.green).fontWeight(.medium)
                        }
                        HStack {
                            Text("RECOVERY RATE").foregroundColor(.green).fontWeight(.bold).opacity(0.6)
                            Text("\(Double(IndiaDetails.TotalRecovered)*100/Double(IndiaDetails.TotalConfirmed), specifier: "%.2f")%")
                        }
                        HStack {
                            Text("DECEASED").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("\(IndiaDetails.TotalDeaths)")
                            Text("↑ \(IndiaDetails.NewDeaths)").foregroundColor(.red).fontWeight(.medium)
                        }
                        HStack {
                            Text("FATALITY RATE").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).opacity(0.6)
                            Text("\(Double(IndiaDetails.TotalDeaths)*100/Double(IndiaDetails.TotalConfirmed), specifier: "%.2f")%")
                        }
                    }
                        Section(header: Text("Statewise distribution")){
                        ForEach(India, id: \.state){ item in
                        StateCell(state: item, stateDetails: stateDetails)}
                    }
                    }.listStyle(InsetGroupedListStyle())
                    .navigationTitle("🇮🇳 India")
                }.onAppear(perform: loadStatesData)
                .pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
                    .onAppear(perform: loadCountriesData)
                .tabItem {
                    Image(systemName: "mappin")
                    Text("India")
                }
            
            
            NavigationView{
                List(Countries, id: \.Country) { item in
                    CountryCell(country: item, countryDetails: countryDetails)
                }.onAppear(perform: loadCountriesData).pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                        }
                }
                .pullToRefresh(isShowing: $isShowing) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowing = false
                    }
                }
                .navigationTitle("🦠 All Countries")
            }
            .tabItem {
                Image(systemName: "map")
                Text("Countries")
            }
            
            NavigationView{
                List{
                    Section{
                        Toggle(isOn: $enableCustom) {
                                Text("Enable custom tab")
                            }
                    if enableCustom {
                        TextField("Custom tab name", text: $customTab)
                        Picker("Custom tab icon", selection: $customTabIcon){
                                ForEach(0..<iconOptions.count){optionNumber in
                                    HStack {
                                        Text(iconOptions[optionNumber]).padding(.trailing, 10)
                                        Image(systemName: iconOptions[optionNumber])
                                    }
                                }
                            }
                        }
                    }
                    
                    Section{
                        Toggle(isOn: $enableNews) {
                                Text("Enable News feed")
                            }
                    }
                    
                    Section(header: Text("COUNTRIES")){
                        Toggle(isOn: $countryDetails) {
                                Text("Expanded list view")
                            }
                        Toggle(isOn: $countryDetailsTop10) {
                                Text("Expanded view for top 10")
                            }
                    }
                    
                    Section(header: Text("STATEWISE DISTRIBUTION")){
                        Toggle(isOn: $stateDetails) {
                                Text("Detailed list view")
                            }
                    }

                }.listStyle(InsetGroupedListStyle())
                .padding(.top, 20)
                .navigationTitle("⚙️ Settings")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
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
    var countryDetails : Bool
    var body: some View {
        
            NavigationLink(destination: CountryDetail(country: country))
            {
                Text(country.Flag).font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(country.Country).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                    }
                    .padding(.vertical, 5.0)
                   
                    if countryDetails {
                        VStack(alignment: .leading){
                            HStack {
                                Text("CONFIRMED").font(.footnote).foregroundColor(.orange).fontWeight(.bold)
                                Text("\(country.TotalConfirmed)").font(.footnote)
                                Text("↑\(country.NewConfirmed)").font(.footnote).fontWeight(.medium).foregroundColor(.orange)
                            }
                            HStack {
                                Text("RECOVERED").font(.footnote).foregroundColor(.green).fontWeight(.bold)
                                country.TotalRecovered != 0 ? Text("\(country.TotalRecovered)").font(.footnote) : Text("Not Available").font(.footnote)
                                country.TotalRecovered != 0 ? Text("↑\(country.NewRecovered)").font(.footnote).fontWeight(.bold).foregroundColor(.green) : Text("")
                            }
                            HStack {
                                Text("DECEASED").font(.footnote).foregroundColor(.red).fontWeight(.bold)
                                Text("\(country.TotalDeaths)").font(.footnote)
                                Text("↑\(country.NewDeaths)").font(.footnote).fontWeight(.medium).foregroundColor(.red)
                            }

                        }
                    }
                    
                    
                }
            }
    }
}

struct StateCell: View {
    var state : IndiaStates
    var stateDetails : Bool
    var body: some View {
        NavigationLink(destination: StateDetail(districts: state.districtData, state: state))
        {
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(state.state).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                }
                
                if stateDetails{
                    VStack(alignment: .leading){
                        HStack {
                            Text("CONFIRMED").font(.footnote).foregroundColor(.orange).fontWeight(.bold)
                            Text("\(state.confirmed)").font(.footnote)
                            Text("↑\(state.cChanges)").font(.footnote).fontWeight(.medium).foregroundColor(.orange)
                        }
                        HStack {
                            Text("RECOVERED").font(.footnote).foregroundColor(.green).fontWeight(.bold)
                            Text("\(state.recovered)").font(.footnote)
                            Text("↑\(state.rChanges)").font(.footnote).fontWeight(.bold).foregroundColor(.green)
                        }
                        HStack {
                            Text("DECEASED").font(.footnote).foregroundColor(.red).fontWeight(.bold)
                            Text("\(state.deaths)").font(.footnote)
                            Text("↑\(state.dChanges)").font(.footnote).fontWeight(.medium).foregroundColor(.red)
                        }

                    }
                }
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

struct GlobalSummary: View {
    var Global: Result
    @State private var isShowing = false
    
    var body: some View {
        List{
            Section(header: Text("Overview")){
                HStack {
                    Text("CONFIRMED").foregroundColor(.orange).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(Global.TotalConfirmed)")
                    Text("↑ \(Global.NewConfirmed)").foregroundColor(.orange).fontWeight(.medium)
                }
                HStack {
                    Text("ACTIVE").foregroundColor(.blue).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(Global.TotalConfirmed - Global.TotalRecovered)")
                    Text("↑ \(Global.NewConfirmed - Global.NewRecovered)").foregroundColor(.blue).fontWeight(.medium)
                }
                HStack {
                    Text("RECOVERED").foregroundColor(.green).fontWeight(.bold)
                    Text("\(Global.TotalRecovered)")
                    Text("↑ \(Global.NewRecovered)").foregroundColor(.green).fontWeight(.medium)
                }
                HStack {
                    Text("RECOVERY RATE").foregroundColor(.green).fontWeight(.bold).opacity(0.6)
                    Text("\(Double(Global.TotalRecovered)*100/Double(Global.TotalConfirmed), specifier: "%.2f")%")
                }
                HStack {
                    Text("DECEASED").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(Global.TotalDeaths)")
                    Text("↑ \(Global.NewDeaths)").foregroundColor(.red).fontWeight(.medium)
                }
                HStack {
                    Text("FATALITY RATE").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).opacity(0.6)
                    Text("\(Double(Global.TotalDeaths)*100/Double(Global.TotalConfirmed), specifier: "%.2f")%")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .pullToRefresh(isShowing: $isShowing) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
            }
        }
        .navigationTitle("🌍 Global Summary")
    }
}
