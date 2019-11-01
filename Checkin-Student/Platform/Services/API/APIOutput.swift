//
//  APIOutput.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

// swiftlint:disable final_class
class APIOutput: APIOutputBase {
    var message: String?
    var statusCode = -1
    
    override func mapping(map: Map) {
        message <- map["message"]
        statusCode <- map["status"]
    }
}
