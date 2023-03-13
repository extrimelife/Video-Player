//
//  HomeModel.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 12.03.2023.
//

import Foundation

struct Json: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let title: String
    let video: [Video]
}

struct Video: Decodable {
    let description: String
    let sources: String
    let subtitle: String
    let thumb: String
    let title: String
}










