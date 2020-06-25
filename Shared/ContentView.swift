//
//  ContentView.swift
//  Shared
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI

struct ContentView: View {
    var countries: [Country] = []
    
    var body: some View {
        NavigationView{
            List{
                ForEach(countries){
                    country in
                    CountryCell(country: country)
                   
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(countries: testData)
            .preferredColorScheme(.dark)
    }
}

struct CountryCell: View {
    var country : Country
    var body: some View {
        NavigationLink(destination: CountryDetail(country: country))
        {
            Text(country.thumbnail).font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(country.pos)
                        .font(.subheadline)
                        .fontWeight(.thin).foregroundColor(.secondary)
                    Text(country.name).font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/).fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    
                    Text("🟡 \(country.confirmedCount)").font(.footnote)
                    country.recoveredCount == 0 ? Text("🟢 N/A").font(.footnote) : Text("🟢 \(country.recoveredCount)").font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                    Text("🔴 \(country.deceasedCount)").font(.footnote)
                    
                    
                }
                .padding(.vertical, 5.0)
                
                
            }
        }.navigationTitle("Worldwide")
    }
}
