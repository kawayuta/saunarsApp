//
//  SaunaSmall.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            URLImage(url: "http://localhost:3000/sauna_images/1.jpg")
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
