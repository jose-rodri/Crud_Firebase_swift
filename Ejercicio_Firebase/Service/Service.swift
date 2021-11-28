//
//  Service.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 8/11/21.
//

//import Foundation
//import Alamofire
//
//
//public class Service {
//    fileprivate var baseUrl  = ""
//    
//    init(baseUrl: String) {
//        self.baseUrl = baseUrl
//    }
//    
//    public func getDataMovies(endPoint: String) {
//        AF.request(baseUrl + endPoint, method: .get, parameters: nil , encoding: URLEncoding.default , headers: nil,interceptor: nil).response { (respondeData) in
//            
//            guard let  data = respondeData.data else { return }
//            do {
//                let movies = try JSONDecoder().decode([MoviesResponse].self, from: data)
//                print("movie \(movies)")
//            } catch {
//                print("ERRRORR ")
//            }
//          
//        }
//    }
//}
