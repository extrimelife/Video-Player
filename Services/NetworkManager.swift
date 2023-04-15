//
//  NetworkManager.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 13.03.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetchData(completion: @escaping (_ result: [Category]) -> Void) {
        guard let fileLocation = Bundle.main.url(forResource: "simple", withExtension: "json") else {return}
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(json)
            let jsonModel = try JSONDecoder().decode(JsonModel.self, from: data)
            completion(jsonModel.categories)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        } .resume()
    }
}
