//
//  MapView.swift
//  saucialApp
//
//  Created by kawayuta on 3/28/21.
//

import SwiftUI
import UIKit
import MapKit
import Cluster
import Combine
import GoogleMapsTileOverlay
import RxSwift
import RxCocoa

struct MapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: MapViewModel
    let manager: ClusterManager
    var didChangeCancellable: AnyCancellable?
    @State var anotationsBuildings: [Building] = []
    @Binding var resultState: Bool
    @State var LanchSearchState: Bool = false
    
    init(viewModel: MapViewModel, resultState: Binding<Bool>) {
        self.viewModel = viewModel
        self.manager = viewModel.clusterManager
        _resultState = resultState
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        addCustomOverlay(mapView: view)
        view.delegate = context.coordinator
        view.region = viewModel.region
        view.showsUserLocation = true
        view.userTrackingMode = .followWithHeading
        
        return view
    }
    
    private func addCustomOverlay(mapView: MKMapView) {
            guard let jsonURL = Bundle.main.url(forResource: "tileOverlay", withExtension: "json") else { return }

            do {
                let gmTileOverlay = try GoogleMapsTileOverlay(jsonURL: jsonURL)
                gmTileOverlay.canReplaceMapContent = true
                mapView.addOverlay(gmTileOverlay, level: .aboveRoads)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
        viewModel.buildings.publisher.map { items in
            manager.reload(mapView: mapView)
            let addedState = manager.annotations.contains(where: { items.name == $0.title })
            if !addedState {
                DispatchQueue.main.async { anotationsBuildings.append(items) }
                let annotation = ClusterAnnotation(coordinate: items.coordinate)
                annotation.sauna_id = String(items.sauna_id)
                annotation.image_url = String(items.image_url)
                annotation.index_id = items.index_id
                annotation.title = items.name // annotation isempty? hantei
                annotation.subtitle = String(items.index_id) // pageID annotation tap
                manager.add(annotation)
                manager.reload(mapView: mapView)
            } else {
            }
        }
        mapView.region = viewModel.region
    }

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self, viewModel: viewModel, resultState: $resultState, LanchSearchState: $LanchSearchState)
    }
    
    private var tapCallback: ((MKAnnotationView) -> ())?    // << this one !!
    
    @inlinable public func onAnnotationTapped(site: @escaping (MKAnnotationView) -> ()) -> some View {
        var newMapView = self
        newMapView.tapCallback = site
        return newMapView
    }
    
    public class MapViewCoordinator: NSObject, MKMapViewDelegate, UIAdaptivePresentationControllerDelegate {
        var mapView: MapView
        var manager: ClusterManager
        var viewModel: MapViewModel
        @Binding var resultState: Bool
        @Binding var LanchSearchState: Bool
        
        init(_ control: MapView, viewModel: MapViewModel, resultState: Binding<Bool>, LanchSearchState: Binding<Bool>) {
            self.mapView = control
            self.manager = control.manager
            self.viewModel = viewModel
            _resultState = resultState
            _LanchSearchState = LanchSearchState
            
        }
        public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            
            if let annotation = view.annotation as? ClusterAnnotation {
                if annotation.title != nil {
                    viewModel.tapSaunaId = annotation.sauna_id
                    viewModel.tapState = true
                } else {
                    let tapRegion = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude),
                        span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 2, longitudeDelta: mapView.region.span.longitudeDelta / 2))
                    
                    mapView.setRegion(tapRegion, animated: true)
                }
            }
            
            self.mapView.tapCallback?(view)
            
        }
        
        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if( annotation is MKUserLocation ) { return nil }
            
            if let annotation = annotation as? ClusterAnnotation {
                return CountClusterAnnotationView(annotation: annotation, reuseIdentifier: "cluster")
                
            } else {
                return MKAnnotationView(annotation: annotation, reuseIdentifier: "")
            }
        }
            
        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            viewModel.region = mapView.region
            if LanchSearchState {viewModel.searchSaunaList(writeRegion: false)}
            else {DispatchQueue.main.async { [self] in LanchSearchState = true }}
            
            if !resultState && viewModel.saunas.count > 0 {DispatchQueue.main.async { [self] in resultState = true }}
            manager.reload(mapView: mapView)
            
           
        }
        
        public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            manager.reload(mapView: mapView)
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if let tileOverlay = overlay as? MKTileOverlay {
                    return MKTileOverlayRenderer(tileOverlay: tileOverlay)
                }
                return MKOverlayRenderer(overlay: overlay)
        }
        
    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension ClusterAnnotation {
    private struct additional {
        static var sauna_id: String = ""
        static var image_url: String = ""
        static var index_id: Int?
    }

    var sauna_id: String {
        get {
            guard let theId = objc_getAssociatedObject(self, &additional.sauna_id) as? String else {
                return ""
            }
            return theId
        }
        set {
            objc_setAssociatedObject(self, &additional.sauna_id, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var image_url: String {
        get {
            guard let theUrl = objc_getAssociatedObject(self, &additional.image_url) as? String else {
                return ""
            }
            return theUrl
        }
        set {
            objc_setAssociatedObject(self, &additional.image_url, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var index_id: Int? {
        get {
            guard let indexId = objc_getAssociatedObject(self, &additional.index_id) as? Int else {
                return nil
            }
            return indexId
        }
        set {
            objc_setAssociatedObject(self, &additional.index_id, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
extension ClusterAnnotationView {
    private struct additional {
        static var imageView: UIImageView = {
            let image = UIImageView()
            image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            image.backgroundColor = .clear
            return image
        }()
    }
}

class CountClusterAnnotationView: ClusterAnnotationView {
    
    lazy var imageView: UIImageView = {
           let view = UIImageView()
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
           self.addSubview(view)
           return view
       }()
    
    override func configure() {
        super.configure()
        
        guard let annotation = annotation as? ClusterAnnotation else { return }
        let count = annotation.annotations.count
        _ = annotation.sauna_id
        let image_url = annotation.image_url
        let diameter = radius(for: count) * 4
        self.frame.size = CGSize(width: diameter, height: diameter)
        self.countLabel.layer.masksToBounds = true
        self.imageView.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.layer.backgroundColor = UIColor.blue.cgColor
        self.countLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.imageView.frame = CGRect(x:0, y:0, width:diameter, height:diameter)
        self.imageView.layer.cornerRadius = self.frame.width / 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = self.frame.width / 3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.3
        if image_url != "" {
            self.imageView.cacheImage(imageUrlString: "\(API.init().imageUrl)\(image_url)")
            self.layer.cornerRadius = self.frame.width / 3
        } else {
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
       
    func radius(for count: Int) -> CGFloat {
        if count < 5 {
            return 12
        } else if count < 10 {
            return 16
        } else {
            return 20
        }
    }
}
