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
    
    static let share = NetworkManager()
    
    private init () {}
    
    func fetchingJsonData(handler: @escaping (_ result: [Category]) -> (Void)) {
        guard let fileLocation = Bundle.main.url(forResource: "simple", withExtension: "json") else {return}
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(json)
            let decode = try JSONDecoder().decode(JsonModel.self, from: data)
            
            handler(decode.categories)
            
        } catch {
            print("Parsing Error")
        }
        
    }
    
    func fetchImage(from url: String?, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        DispatchQueue.global().async {
            guard let imageUrl = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                completion(imageUrl)
            }
        }
    } 
}
