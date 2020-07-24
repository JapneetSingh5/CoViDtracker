//
//  CountryDetail.swift
//  CoViDtracker
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI
import SwiftUIRefresh

struct CountryDetail: View {
    var country: Result
    @State private var isShowing = false
    
    var body: some View {
        
        List{
        Section(header: Text("Overview")){
            HStack {
                Text("CONFIRMED").foregroundColor(.orange).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("\(country.TotalConfirmed)")
                Text("↑ \(country.NewConfirmed)").foregroundColor(.orange).fontWeight(.medium)
            }
            HStack {
                Text("ACTIVE").foregroundColor(.blue).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("\(country.TotalConfirmed - country.TotalRecovered)")
                Text("↑ \(country.NewConfirmed - country.NewRecovered)").foregroundColor(.blue).fontWeight(.medium)
            }
            HStack {
                Text("RECOVERED").foregroundColor(.green).fontWeight(.bold)
                Text("\(country.TotalRecovered)")
                Text("↑ \(country.NewRecovered)").foregroundColor(.green).fontWeight(.medium)
            }
            HStack {
                Text("RECOVERY RATE").foregroundColor(.green).fontWeight(.bold).opacity(0.6)
                Text("\(Double(country.TotalRecovered)*100/Double(country.TotalConfirmed), specifier: "%.2f")%")
            }
            HStack {
                Text("DECEASED").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("\(country.TotalDeaths)")
                Text("↑ \(country.NewDeaths)").foregroundColor(.red).fontWeight(.medium)
            }
            HStack {
                Text("FATALITY RATE").foregroundColor(.red).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).opacity(0.6)
                Text("\(Double(country.TotalDeaths)*100/Double(country.TotalConfirmed), specifier: "%.2f")%")
            }
        }
        }.listStyle(InsetGroupedListStyle())
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                }
            }
            .navigationTitle("\(country.Flag)\(country.Country)")
            
        
        
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CountryDetail(country: testData[0])
        }
    }
}
