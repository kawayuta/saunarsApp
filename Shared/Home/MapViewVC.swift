//
//  testVC.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/19/21.
//

import UIKit
import SwiftUI
import Combine

struct MapViewVC: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIHostingController
    let viewModel: MapViewModel
    @Binding var resultState: Bool
    
    init(viewModel: MapViewModel, resultState: Binding<Bool>) {
        self.viewModel = viewModel
        _resultState = resultState
        
    }
    func makeUIViewController(context: Context) -> UIViewController {
        let mapViewVC = UIHostingController(rootView: MapView(viewModel: viewModel, resultState: $resultState))
        
        mapViewVC.view.translatesAutoresizingMaskIntoConstraints = false

        return mapViewVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
