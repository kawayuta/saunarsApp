//
//  resultCardView.swift
//  saucialApp
//
//  Created by kawayuta on 4/22/21.
//

import SwiftUI

struct resultCardMainView: View {
        let sauna: Sauna?

        init(sauna: Sauna? = nil) {
            self.sauna = sauna
        }

    
    var body: some View {
        
        VStack {
            if let sauna = sauna {
                let image_url = sauna.image.url
                URLImageView("\(API.init().imageUrl)\(image_url)")
                    .frame(width: 150, height: 76, alignment: .center)
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                Text(sauna.name_ja)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                    .frame(width: 150, height: 15, alignment: .leading)
                    .lineLimit(1)
                    .font(.subheadline, weight: .bold)
                    .foregroundColor(.black)
                Text(sauna.address)
                    .frame(width: 150, height: 15, alignment: .leading)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 0) {
                    Image(systemName: "yensign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18)
                        .foregroundColor(Color(hex: "44556b"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    
                    let price = sauna.price == 0 ? "情報なし" : String(sauna.price)
                    Text(String(price))
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                }
                .frame(width: 150, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            }
        }
        
    }
}

struct resultCardMainView_Previews: PreviewProvider {
    static var previews: some View {
        resultCardMainView()
    }
}
