//
//  File.swift
//
//
//  Created by Mephisto on 2022/2/28.
//

import Foundation

public let kBodyKey = "body"
public let kDataKey = "data"

public let appDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

public let appEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()
