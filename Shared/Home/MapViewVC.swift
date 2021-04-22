//
//  testVC.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/19/21.
//

import UIKit
import SwiftUI

struct MapViewVC: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIHostingController
    let viewModel: MapViewModel
    @Binding var resultState: Bool
    
    init(viewModel: MapViewModel, resultState: Binding<Bool>) {
        self.viewModel = viewModel
        _resultState = resultState
        
    }
    func makeUIViewController(context: Context) -> UIViewController {
        let mapViewVC = UIHostingController(rootView: MapView(viewModel: viewModel, resultState: $resultState), ignoreSafeArea: true)
        
        mapViewVC.view.translatesAutoresizingMaskIntoConstraints = false

        return mapViewVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
extension UIHostingController {
    convenience public init(rootView: Content, ignoreSafeArea: Bool) {
        self.init(rootView: rootView)
        
        if ignoreSafeArea {
            disableSafeArea()
        }
    }
    
    func disableSafeArea() {
        guard let viewClass = object_getClass(view) else { return }
        
        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
            
            if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
                    return .zero
                }
                class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
            }
            
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
}
