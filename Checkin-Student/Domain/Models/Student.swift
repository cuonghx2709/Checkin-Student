//
//  Student.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/30/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

struct Student {
    var id = 0
    var vectors = ""
    var birthDay = ""
    var email = ""
    var name = ""
}

extension Student: Then { }

extension Student: Mappable {
    
    init?(map: Map) { self.init() }
    
    mutating func mapping(map: Map) {
        id <- map["student_id"]
        vectors <- map["vectors"]
        birthDay <- map["birthday"]
        email <- map["email"]
        name <- map["student_name"]
    }
}
