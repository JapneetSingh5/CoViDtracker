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
                        HStack {
                            Text("Confirmed").font(.largeTitle).fontWeight(.bold)
                            Text("↑\(country.NewConfirmed)")
                        }
                        Text("\(country.TotalConfirmed)").font(.title)
                    }
                    Spacer()
                }
                .padding(.vertical).background(Color.orange)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("Active").font(.largeTitle).fontWeight(.bold)
                            Text("↑\(country.NewConfirmed - country.NewRecovered)")
                        }
                        Text("\(country.TotalConfirmed - country.TotalDeaths - country.TotalRecovered)").font(.title)
                    }
                    Spacer()
                }
                .padding(.vertical).background(Color.blue)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("Recovered").font(.largeTitle).fontWeight(.bold)
                            Text("↑\(country.NewRecovered)")
                        }
                        country.TotalRecovered == 0 ? Text(" N/A").font(.title) : Text(" \(country.TotalRecovered)").font(.title)
                        
                    }
                    Spacer()
                }.padding(.vertical).background(Color.green)
                HStack{
                    Spacer()
                    VStack {
                        Text("Recovery Rate:" ).fontWeight(.bold).font(.title)
                        Text("\((Double(country.TotalRecovered) / Double(country.TotalConfirmed) * 100), specifier: "%.2f")%").font(.title2)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.green.opacity(0.9))
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("Deceased").font(.largeTitle).fontWeight(.bold)
                            Text("↑\(country.NewDeaths)")
                        }
                        Text("\(country.TotalDeaths)").font(.title)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.red)
                HStack{
                    Spacer()
                    VStack {
                        Text("Fatality Rate:" ).fontWeight(.bold).font(.title)
                        Text("\((Double(country.TotalDeaths) / Double(country.TotalConfirmed) * 100), specifier: "%.2f")%").font(.title2)
                    }
                    Spacer()
                }.padding(.vertical).background(Color.red.opacity(0.9))
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
