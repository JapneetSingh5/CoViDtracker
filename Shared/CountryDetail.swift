//
//  CountryDetail.swift
//  CoViDtracker
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI

struct CountryDetail: View {
    var country: Result
    
    var body: some View {
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Confirmed Cases").font(.largeTitle).fontWeight(.bold)
                        Text("\(country.confirmed)").font(.title)
                    }
                    Spacer()
                }
                .padding(.vertical).background(Color.yellow)
                HStack {
                    Spacer()
                    VStack {
                        Text("Recovered").font(.largeTitle).fontWeight(.bold)
                        country.recovered == 0 ? Text(" N/A").font(.title) : Text(" \(country.recovered)").font(.title)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.green)
                HStack {
                    Spacer()
                    VStack {
                        Text("Deceased").font(.largeTitle).fontWeight(.bold)
                        Text("\(country.deaths)").font(.title)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.red)
            }
            .navigationTitle( country.country_region).navigationBarTitleDisplayMode(.inline)
            
        
        
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        Text("blank space")
        }
    }
}
