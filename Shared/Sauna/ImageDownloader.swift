//
//  ImageDownloader.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//
import Foundation
import SwiftUI
import UIKit

struct URLImageViewSta: View {
    @StateObject var imageLoader: ImageLoaderAndCacheSta
    
    init(_ url: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderAndCacheSta(imageURL: url))
    }

    var body: some View {
          Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
              .resizable()
            .clipped()
    }
}


struct URLImageView: View {
    @ObservedObject var imageLoader: ImageLoaderAndCache
    
    init(_ url: String) {
        imageLoader = ImageLoaderAndCache(imageURL: url)
    }

    var body: some View {
          Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
              .resizable()
            .clipped()
    }
}

class ImageLoaderAndCacheSta: ObservableObject {
    
    @Published var imageData = Data()
    var imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
        fetchLoad()
    }
    
    func fetchLoad() {
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            print("got image from cache")
            
            self.imageData = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        print("downloaded from internet")
                        self.imageData = data
                    }
                }
            }).resume()
        }
    }
}


class ImageLoaderAndCache: ObservableObject {
    
    @Published var imageData = Data()
    var imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
        fetchLoad()
    }
    
    func fetchLoad() {
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            print("got image from cache")
            
            self.imageData = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        print("downloaded from internet")
                        self.imageData = data
                    }
                }
            }).resume()
        }
        
    }
}


extension UIImageView {

    //NSCacheのインスタンスを生成しておく。ここに、どんどんキャッシュ化されたものが保存されていく。
    static let imageCache = NSCache<AnyObject, AnyObject>()

    //読み込むURLのstringを引数にする。
    func cacheImage(imageUrlString: String) {

        //引数のimageUrlStringをURLに型変換する。
        let url = URL(string: imageUrlString)

        //引数で渡されたimageUrlStringがすでにキャッシュとして保存されている場合は、キャッシュからそのimageを取り出し、self.imageに代入し、returnで抜ける。
        if let imageFromCache = UIImageView.imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }

        //上記のifに引っかからないということは、キャッシュとして保存されていないということなので、以下でキャッシュ化をしていく。
        //URLSessionクラスのdataTaskメソッドで、urlを元にして、バックグランドでサーバーと通信を行う。
        //{ 以降はcompletionHandler(クロージャー)で、通信処理が終わってから実行される。
        //dataはサーバーからの返り値。urlResponseは。HTTPヘッダーやHTTPステータスコードなどの情報。リクエストが失敗したときに、errorに値が入力される。失敗しない限り、nilとなる。
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in

            //errorがnilじゃないということは、リクエストに失敗しているということ。returnで抜け出す。
            if error != nil {
                print(error as Any)
                return
            }

            //リクエストが成功して、サーバーからのresponseがある状態。
            //しかし、UIKitのオブジェクトは必ずメインスレッドで実行しなければならないので、DispatchQueue.mainでメインキューに処理を追加する。非同期で登録するので、asyncで実装。
            DispatchQueue.main.async {

                //サーバーからのレスポンスのdataを元にして、UIImageを取得し、imageToCacheに代入。
                let imageToCache = UIImage(data:data!)

                //self.imageにimageToCacheを代入。
                self.image = imageToCache

                //keyをimageUrlStringとして、imageToCacheをキャッシュとして保存する。
                UIImageView.imageCache.setObject(imageToCache!, forKey: imageUrlString as AnyObject)
            }
        }.resume()
    }
}
