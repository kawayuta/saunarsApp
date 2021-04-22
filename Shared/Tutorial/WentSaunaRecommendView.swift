//
//  WentSaunaRecommendView.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import SwiftUI
import UIKit

struct Sauna: Identifiable {
    var id: Int
    var name: String
    var checked: Bool
}

let saunas = [
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 3, name: "safdu", checked: true),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
    Sauna(id: 0, name: "サウナ名", checked: true),
    Sauna(id: 1, name: "sa23u", checked: true),
    Sauna(id: 2, name: "saru", checked: false),
]

struct WentSaunaRecommendView: View {
    var body: some View {
        HStack(spacing: 0) {
            List {
                ForEach(saunas) { sauna in
                    HStack{
                        sauna.checked == true ?
                            Text("☑").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(Color.blue):
                            Text("□").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text(sauna.name).padding()
                    }
                }
            }.frame(width: .infinity, height: .infinity, alignment: .top)
        }
    }
}

struct WentSaunaRecommendView_Previews: PreviewProvider {
    static var previews: some View {
        WentSaunaRecommendView()
    }
}
