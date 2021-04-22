//
//  resultCardView.swift
//  saucialApp
//
//  Created by kawayuta on 3/26/21.
//

import SwiftUI

struct resultCardRoomsView: View {
        let rooms: [Rooms]?

        init(rooms: [Rooms]? = nil) {
            self.rooms = rooms
        }

    
    var body: some View {
        
        
        ForEach(rooms!.indices, id: \.self) { rolesindex in
            HStack {
                let sauna = rooms!.reversed()[rolesindex]
                Text(sauna.gender == 0 ? "男" : "女")
                    .font(.caption, weight: .bold)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .background(sauna.gender == 0 ? Color.blue : Color.red)
                
                if let sauna_temperature = sauna.sauna_temperature {
                    Text("サ").font(.caption).fontWeight(.bold)
                    .foregroundColor(.black)
                    Text("\(sauna_temperature)℃").font(.caption).fontWeight(.bold)
                        .foregroundColor(.black)
                }
                if let mizu_temperature = sauna.mizu_temperature {
                    Text("水").font(.caption).fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("\(mizu_temperature)℃").font(.caption).fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
            }
        }
    }
}

struct resultCardRoomsView_Previews: PreviewProvider {
    static var previews: some View {
        resultCardRoomsView()
    }
}
