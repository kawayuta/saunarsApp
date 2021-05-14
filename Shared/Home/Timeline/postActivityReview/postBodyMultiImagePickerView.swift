//
//  postBodyMultiImagePickerView.swift
//  saucialApp
//
//  Created by kawayuta on 5/6/21.
//

import Foundation
import SwiftUI
import UIKit
import SnapKit
import PhotosUI
import os


struct postBodyMultiImagePickerView: View {
    @State private var showPHPicker:Bool = false
    @StateObject var viewModel: ReviewViewModel
    
    
   init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 3
        config.preferredAssetRepresentationMode = .current
        return config
    }
    let logger = Logger(subsystem: "com.smalldesksoftware.PHPickerSample", category: "PHPickerSample")

    var columns: [GridItem] = Array(repeating: .init(.fixed(80)), count: 3)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HStack {
                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: viewModel.selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.clear, lineWidth: 10))
                            Button(action: {
                                viewModel.selectedImages.remove(at: index)
                            }, label: {
                                Image(systemName: "minus.circle")
                                    .font(.title3)
                                    .foregroundColor(Color(hex: "fff"))
                                    .background(Color(hex: "bbb"))
                                    .cornerRadius(20)
                                    .frame(width: 20, height: 20)
                            })
                            .padding(EdgeInsets(top: -8, leading: 0, bottom: 0, trailing: -8))
                        }
                    }
                }
                if viewModel.selectedImages.count < 3 {
                    Button(action: {
                        showPHPicker.toggle()
                    }, label: {
                        Group {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                        }
                        .frame(width: 80, height: 80)
                        .background(Color(hex: "ddd"))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.clear, lineWidth: 10))
                    })
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            
        }
        .sheet(isPresented: $showPHPicker) {
            SwiftUIPHPicker(configuration: postBodyMultiImagePickerView.config, viewModel: viewModel) { results in
                for result in results {
                    let itemProvider = result.itemProvider
                    if itemProvider.canLoadObject(ofClass: UIImage.self) {
                        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            if let image = image as? UIImage {
                                DispatchQueue.main.async {
                                    self.viewModel.selectedImages.append(image)
                                }
                            }
                            if let error = error {
                                logger.error("\(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
}

public typealias PHPickerViewCompletionHandler = ( ([PHPickerResult]) -> Void)

public struct SwiftUIPHPicker: UIViewControllerRepresentable {
    var configuration: PHPickerConfiguration
    var completionHandler: PHPickerViewCompletionHandler?
    @StateObject var viewModel: ReviewViewModel
    
    let logger = Logger(subsystem: "com.smalldesksoftware.SwiftUIPHPicker", category: "SwiftUIPHPicker")
    
   init(configuration: PHPickerConfiguration, viewModel: ReviewViewModel, completion: PHPickerViewCompletionHandler? = nil) {
        self.configuration = configuration
        if viewModel.paramsImages.count == 0 { self.configuration.selectionLimit = 3 }
        if viewModel.paramsImages.count == 1 { self.configuration.selectionLimit = 2 }
        if viewModel.paramsImages.count == 2 { self.configuration.selectionLimit = 1 }
        self.completionHandler = completion
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public func makeCoordinator() -> Coordinator {
        logger.debug("makeCoordinator called")
        return Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        print(2)
        logger.debug("makeUIViewController called")
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        print(3)
        logger.debug("updateUIViewController called")
    }
    
    
    public class Coordinator : PHPickerViewControllerDelegate {
        let parent: SwiftUIPHPicker
        
        init(_ parent: SwiftUIPHPicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(4)
            parent.logger.debug("didFinishPicking called")
            picker.dismiss(animated: true)
            self.parent.completionHandler?(results)
        }
    }

}
