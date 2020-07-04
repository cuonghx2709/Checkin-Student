//
//  API+Checkin.swift
//  Checkin-Student
//
//  Created by cuong hoang on 5/19/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func checkin(_ input: CheckinInput) -> Observable<CheckinOutput> {
        return request(input)
    }
    
    func updateLink(_ input: UploadLinkInput) -> Observable<APIOutput> {
        return request(input)
    }
}

extension API {
    final class CheckinInput: APIInput {
        init(studentId: Int, latitude: Double, longitude: Double) {
            let params: [String: Any] = [
                "student_id": studentId,
                "lat": latitude,
                "long": longitude
            ]
            super.init(urlString: Urls.checkin,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
    
    final class CheckinOutput: APIOutput {
        
        private(set) var insertId: Int = 0
        private(set) var courseId: Int = 0
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            insertId <- map["insertId"]
            courseId <- map["course_id"]
        }
    }
    
    final class UploadLinkInput: APIInput {
        init(link: String, insertId: Int) {
            let params: [String: Any] = [
                "upload_link": link
            ]
            super.init(urlString: String(format: "%@/%d", Urls.checkin, insertId),
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
}
