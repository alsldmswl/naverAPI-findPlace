//
//  DataModel.swift
//  GoodPlace_app
//
//  Created by eun-ji on 2023/03/07.
//

import Foundation

// MARK: - Welcome
struct DataModel: Codable {
    let lastBuildDate: String
    var total:Int 
    var start:Int
    var display:Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let address: String
}
