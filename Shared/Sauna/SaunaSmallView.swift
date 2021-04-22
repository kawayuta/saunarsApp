//
//  SaunaSmall.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import SwiftUI

struct SaunaSmallView: View {
    
    var saunaId = String(describing: UserDefaults.standard.string(forKey: "saunaId")!)
    var body: some View {
        VStack {
            URLImageView("\(API.init().host)/sauna_images/\(saunaId).jpg").aspectRatio(contentMode: .fit)
            
        }
    }
}

struct SaunaSmallView_Previews: PreviewProvider {
    static var previews: some View {
        SaunaSmallView()
    }
}
