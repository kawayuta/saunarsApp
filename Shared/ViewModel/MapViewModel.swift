//
//  MapViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/23/21.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import URLQueryItemsCoder
import Cluster

final class MapViewModel: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var clusterManager: ClusterManager = { [self] in
        let manager = ClusterManager()
        manager.maxZoomLevel = 20
        manager.minCountForClustering = 2
        manager.clusterPosition = .nearCenter
        return manager
    }()
    
    @Published var saunas:[Saunas] = []
    @Published var sauna_tags:[SaunaTags] = []
    // 初期表示の座標.
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
    
    @Published var trackingMode: MapUserTrackingMode = .follow
    
    
    @Published var keyword: String = ""
    
    @Published var buildings: [Building] = []
    var builds: [Building] = []
    
    @Published var tapState: Bool = false
    @Published var tapSaunaId: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    var initCurrentRegion: Bool = false
    @Published var currentRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6586, longitude: 139.7454),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
    
    override init() {
        super.init()
        manager.delegate = self
        
        
    }
    
    /// 位置情報のリクエスト.
    func requestUserLocation() {
        manager.startUpdatingLocation()
    }
    
}


struct Building: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let sauna_id: Int
    let is_went: Bool
    let image_url: String
    let index_id: Int
}

extension MapViewModel: CLLocationManagerDelegate {
    
    
    // 位置情報関連の権限に変更があったら呼び出される.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        
        if manager.authorizationStatus == .authorizedWhenInUse {
            print(#function, "権限があるので位置情報をリクエスト.")
            
            // 正確な位置情報を利用する権限があるかどうか.
            if manager.accuracyAuthorization != .fullAccuracy {
                // 正確な位置情報をリクエスト.
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "full_accuracy_message")
            }
            
            manager.startUpdatingLocation()
        } else {
            print(#function, "権限がないので権限をリクエスト.")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // 位置情報が更新されたら呼び出される.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        manager.stopUpdatingLocation()
        
        guard let location = locations.first else { return }
        
        // 取得した位置情報を reigon.center に与える.
        if !initCurrentRegion {
            currentRegion = region
            initCurrentRegion = true
        }
        withAnimation {
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
        }
        
        searchSaunaList(writeRegion: false)
        
//        locationWord(location: location)
    }
    
    func locationWord(location: CLLocation) {
        let georeader = CLGeocoder()
        georeader.reverseGeocodeLocation(location) { (places, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            if let place = places?.first?.administrativeArea {
                if place.contains("県") || place.contains("府") || place.contains("都") {
                    self.keyword = String(place.dropLast())
                } else {
                    self.keyword = place
                }

            }
            
        }
    }
    
    func buildMapCoordinate(saunas: [Saunas], writeRegion: Bool) {
        buildings.removeAll()
        builds.removeAll()
        clusterManager.removeAll()
        
        if let first = saunas.first {
//            let pos = CLLocationCoordinate2D(latitude: first.latitude!, longitude: first.longitude!)
            let firstRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: first.latitude!, longitude: first.longitude!),
                span: MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10))
            if writeRegion { withAnimation { region = firstRegion } }
            
        }
        
        for (index, sauna) in saunas.enumerated() {
            let name: String = sauna.name_ja
            let sauna_id: Int = sauna.id
            let address: String = sauna.address
            let is_went: Bool = sauna.is_went
            let image_url: String = sauna.image.url
            var lat: Double = sauna.latitude ?? 0
            var lng: Double = sauna.longitude ?? 0
            
            let myGeocoder:CLGeocoder = CLGeocoder()
            
            if lat != 0 && lng != 0 {
                let build = Building(name: name,
                                     coordinate: .init(latitude: lat, longitude: lng),
                                     sauna_id: sauna_id,
                                     is_went: is_went,
                                     image_url: image_url,
                                     index_id: index
                )
                let nState = buildings.contains(where: { build.name == $0.name })
                if !nState {
                    builds.append(build)
                    buildings.append(build)
//                    if writeRegion { withAnimation { region.center = build.coordinate } }
                }
                
            } else {
                myGeocoder.geocodeAddressString(address, completionHandler: { [self](placemarks, error) in
                    if(error == nil) {
                        for placemark in placemarks! {
                            let location:CLLocation = placemark.location!
                            lat = location.coordinate.latitude
                            lng = location.coordinate.longitude
                            
                        }
                        if lat > 0 && lng > 0 {
                            let build = Building(name: name,
                                                 coordinate: .init(latitude: lat, longitude: lng),
                                                 sauna_id: sauna_id,
                                                 is_went: is_went,
                                                 image_url: image_url,
                                                 index_id: index
                            )
                            let nState = buildings.contains(where: { build.name == $0.name })
                            if !nState {
                                builds.append(build)
                                buildings.append(build)
//                                if writeRegion { withAnimation { region.center = build.coordinate } }
    //                            if saunas.count == builds.count {
    //                                print("完了")
    //                                print(builds)
    //                                buildings = builds
    //                            }
                            }
                        }
                    } else {}
                })
            }
        }
    }
    
    func addAnnotation() {
//        buildings.forEach {
//            let annotation = Annotation(coordinate: $0.coordinate)
//            clusterManager.add(annotation)
//        }
    }
    
    
    func searchSaunaList(writeRegion: Bool) {
        let userDefaults = UserDefaults.standard
        
        var urlComponents = URLComponents(string: "\(API.init().host)/saunas/search")
        
        
        var queryItems = try! URLQueryItemsEncoder().encode(Property(searchKeyword: keyword))
        let queryItemLat = URLQueryItem(name: "latitude", value: String(region.center.latitude))
        let queryItemLon = URLQueryItem(name: "longitude", value: String(region.center.longitude))
        let queryItemCurrentLat = URLQueryItem(name: "currentLatitude", value: String(currentRegion.center.latitude))
        let queryItemCurrentLon = URLQueryItem(name: "currentLongitude", value: String(currentRegion.center.longitude))
        let queryItemRadius = URLQueryItem(name: "radius", value: keyword != "" ? "1000" : "5")
        let queryItemSortType = URLQueryItem(name: "sortType", value: String(SortProperty().sort))
        queryItems.append(queryItemLat)
        queryItems.append(queryItemLon)
        queryItems.append(queryItemCurrentLat)
        queryItems.append(queryItemCurrentLon)
        queryItems.append(queryItemRadius)
        queryItems.append(queryItemSortType)
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url!)!)
        request.httpMethod = "GET"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        do {
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([Saunas].self, from: data)
                            DispatchQueue.main.async {
                                self.saunas = json
                                buildMapCoordinate(saunas: self.saunas, writeRegion: writeRegion)
                                keyword = ""
                            }
                        } else {
                            print("error")
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            UserDefaults.standard.setValue(self.keyword, forKey: "searchOldKeyword")
        }
    }
    
    
    
    
    func fetchTagList() {
        let userDefaults = UserDefaults.standard
        
        let url = URL(string: "\(API.init().host)/sauna_tags.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        do {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([SaunaTags].self, from: data)
                            DispatchQueue.main.async { self.sauna_tags = json }
                        } else {
                            print("errot")
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            
        }
    }
}
