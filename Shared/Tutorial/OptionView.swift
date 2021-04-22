//
//  OptionView.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import SwiftUI
import PartialSheet


struct OptionView: View {
    
    var popularButton: some View {
        Button("人気順") {
            
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
        .background(Color.init(hex: "BBB"))
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 4))
    }
    
    var locationButton: some View {
        Button("現在地") {
            
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
        .background(Color.init(hex: "BBB"))
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(EdgeInsets(top: 20, leading: 4, bottom: 20, trailing: 15))
    }
    
    var body: some View {
        VStack {
            HStack {
                popularButton
                locationButton
            }
            Spacer()
        }
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView().frame(maxWidth: .infinity, maxHeight: 40)
    }
}
