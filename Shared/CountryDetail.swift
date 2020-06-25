//
//  CountryDetail.swift
//  CoViDtracker
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI

struct CountryDetail: View {
    var country: Country
    
    var body: some View {
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Confirmed Cases").font(.largeTitle).fontWeight(.bold)
                        Text("\(country.confirmedCount)").font(.title)
                    }
                    Spacer()
                }
                .padding(.vertical).background(Color.yellow)
                HStack {
                    Spacer()
                    VStack {
                        Text("Recovered").font(.largeTitle).fontWeight(.bold)
                        country.recoveredCount == 0 ? Text(" N/A").font(.title) : Text(" \(country.recoveredCount)").font(.title)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.green)
                HStack {
                    Spacer()
                    VStack {
                        Text("Deceased").font(.largeTitle).fontWeight(.bold)
                        Text("\(country.deceasedCount)").font(.title)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.red)
            }
            .navigationTitle(country.thumbnail + " " + country.name).navigationBarTitleDisplayMode(.inline)
            
        
        
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        CountryDetail(country: testData[0])
        }
    }
}
