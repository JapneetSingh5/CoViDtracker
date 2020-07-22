//
//  CoViDtrackerApp.swift
//  Shared
//
//  Created by Japneet Singh on /266/20.
//

import SwiftUI

@main
struct CoViDtrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(Global: testData[1], IndiaDetails: testData[0])
        }
    }
}

struct CoViDtrackerApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(Global: testData[1], IndiaDetails: testData[0])
    }
}
