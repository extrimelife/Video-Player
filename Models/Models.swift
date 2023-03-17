//
//  HomeModel.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 12.03.2023.
//

import Foundation

struct JsonModel: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let name: String
    let videos: [Video]
}

struct Video: Codable {
    let description: String
    let sources: String
    let subtitle: String
    let thumb: String
    let title: String
}

struct UserAction {
    var likes: Int
    var views: Int 
}










