//
//  ImagePickAndDisplaySwiftUIView.swift
//  saucialApp
//
//  Created by kawayuta on 5/4/21.
//

import SwiftUI
import Combine
import UIKit

struct ProfileImageView: View {
    @State var image: UIImage?
    @State var showImagePicker: Bool = false
    
    
    @StateObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if image == nil {
                if let image_url = viewModel.user?.avatar?.url {
                    URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .border(Color.white, width: 8, cornerRadius: 28)
                        .cornerRadius(28)
                } else {
                    
                        Image(uiImage: Bundle.main.icon ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .border(Color.white, width: 8, cornerRadius: 28)
                            .cornerRadius(28).grayscale(1)
                }
            } else {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .border(Color.white, width: 8, cornerRadius: 28)
                    .cornerRadius(28)
            }
            Button(action: {
                self.showImagePicker = true
            }) {
                Text("プロフィール画像を変更")
            }
            .frame(width: 180, height: 50, alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
            .foregroundColor(.blue)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
        }.sheet(isPresented: $showImagePicker) {
            ImagePickerView(image: self.$image, viewModel: viewModel)
        }.onAppear() {
            if let image_url = viewModel.user?.avatar?.url {
                image = UIImage(data: ImageLoaderAndCacheSta(imageURL: "\(API.init().imageUrl)\(String(describing: image_url))").imageData)
            }
        }
    }
}
