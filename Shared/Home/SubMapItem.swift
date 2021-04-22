//
//  SubMapItem.swift
//  saucialApp
//
//  Created by kawayuta on 4/14/21.
//

import Foundation
import SwiftUI
import MapKit

struct SubMapItem: Identifiable {
    var id = UUID().uuidString
    var coordinate = CLLocationCoordinate2D()
    var color = Color.red
    var sauna_id = Color.red
}
