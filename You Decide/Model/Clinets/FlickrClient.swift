//
//  FlickrClient.swift
//  You Decide
//
//  Created by Abdullah Bandan on 01/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
class FlickrClient{
     struct Auth {
        static var apikey = "077b6ede468a64f49e09b53d6a017960"
        static var secret = "c2856de2a64ec5d0"
    }
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/?method=flickr.photos"
        case search(String,String,String)
        var stringValue: String {
            switch self {
            case .search(let lat,let lon,let page):
                return Endpoints.base + ".search&api_key="+Auth.apikey+"&lat="+lat+"&lon="+lon+"&per_page=15&&page="+page+"&format=json&nojsoncallback=1"
           }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    

    class func taskForGETRequest< ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,  completion: @escaping (ResponseType?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
          let decoder = JSONDecoder()
          do {
              let responseObject = try decoder.decode(ResponseType.self, from: data)
              DispatchQueue.main.async {
                  completion(responseObject, nil)
              }
          } catch {
              do {
                let errorResponse = try decoder.decode(FlickerRespones.self, from: data) as Error
                  DispatchQueue.main.async {
                      completion(nil, errorResponse)
                    //print(errorResponse.localizedDescription)
                  }
              } catch {
                  DispatchQueue.main.async {
                      completion(nil, error)
                  }
              }
          }
        }
                task.resume()

    }
    
    class func getPhotos(lat: String,lon: String,page: String, completion: @escaping (Bool,[PhotoLocal]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.search(lat, lon,page).url, responseType: PhotoRespones.self) { response, error in
                if let response = response {
                    completion(true,response.photos.photo, nil)
                } else {
                    completion(false,nil, error)
                }
            }
        }
}


