//
//  OpenCageClient.swift
//  You Decide
//
//  Created by Abdullah Bandan on 24/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
class OpenCageClient{
     struct Auth {
        static var apikey = "7a290b15dd0a4e83b6510505c76b8d84"
    }
    enum Endpoints {
        static let base = "https://api.opencagedata.com/geocode/v1"
        case search(String,String)
        var stringValue: String {
            switch self {
            case .search(let lat,let lon):
                return Endpoints.base + "/json?q="+lat+"%2C+"+lon+"&limit=1&language=en&key="+Auth.apikey+"&pretty=1"
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
                    print("1")
                    completion(nil, error)
                }
                return
            }
          let decoder = JSONDecoder()
          do {
              let responseObject = try decoder.decode(ResponseType.self, from: data)
              DispatchQueue.main.async {
                print("2")
                  completion(responseObject, nil)
              }
          } catch {
              do {
                let errorResponse = try decoder.decode(FlickerRespones.self, from: data) as Error
                  DispatchQueue.main.async {
                    print("3")
                      completion(nil, errorResponse)
                  }
              } catch {
                  DispatchQueue.main.async {
                    print("4")
                      completion(nil, error)
                  }
              }
          }
        }
                task.resume()

    }
    
    class func getGeoData(lat: String,lon: String, completion: @escaping (OpenCageRespones?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.search(lat, lon).url, responseType: OpenCageRespones.self) { response, error in
                if let response = response {
                    completion(response, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
}


