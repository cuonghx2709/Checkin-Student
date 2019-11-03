//
//  Course.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

struct Course {
    var name = ""
    var id = 0
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var emailTeacher = ""
    var code = ""
    var place = ""
}

extension Course: Then {}

extension Course: Mappable {
    
    init?(map: Map) { self.init() }
    
    mutating func mapping(map: Map) {
        name <- map["course_name"]
        id <- map["course_id"]
        startDate <- map["start_date"]
        endDate <- map["end_date"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        emailTeacher <- map["teacher_email"]
        code <- map["code"]
        place <- map["place"]
    }
}
