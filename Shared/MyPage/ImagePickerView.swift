//
//  ImagePickerView.swift
//  saucialApp
//
//  Created by kawayuta on 5/4/21.
//
import SwiftUI
import Combine
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @StateObject var viewModel: UserViewModel
    
    init(image: Binding<UIImage?>, viewModel: UserViewModel) {
        _image = image
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @StateObject var viewModel: UserViewModel

        init(image: Binding<UIImage?>, viewModel: UserViewModel) {
            _image = image
            _viewModel = StateObject(wrappedValue: viewModel)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            defer {
                picker.dismiss(animated: true)
            }

            if let image = info[.editedImage] as? UIImage {
                self.image = image
                viewModel.avatar = image
                
            } else if let image = info[.originalImage] as? UIImage {
                self.image = image
                viewModel.avatar = image
            }

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> ImagePickerView.Coordinator {
        let coordinator = Coordinator(image: $image, viewModel: viewModel)
        return coordinator
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.sourceType = .photoLibrary
        imagePickerViewController.delegate = context.coordinator
        imagePickerViewController.allowsEditing = true
        return imagePickerViewController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}
