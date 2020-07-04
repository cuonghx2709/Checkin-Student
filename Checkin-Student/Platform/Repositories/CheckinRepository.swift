//
//  CheckinRepository.swift
//  Checkin-Student
//
//  Created by cuong hoang on 5/19/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

protocol CheckinRepositoryType {
    func checkin(studentId: Int, latitude: Double, longitude: Double) -> Observable<(Int, Int)>
    func updateLink(insertId: Int, link: String) -> Observable<Void>
}

struct CheckinRepository: CheckinRepositoryType {
    func checkin(studentId: Int, latitude: Double, longitude: Double) -> Observable<(Int, Int)> {
        let input = API.CheckinInput(studentId: studentId, latitude: latitude, longitude: longitude)
        return API.shared.checkin(input)
            .map { respone -> (Int, Int) in
                switch respone.statusCode {
                case -1:
                    throw WrongCheckinWithCurrentLocation()
                case -2:
                    throw AlreadyCheckin()
                case 1:
                    return (respone.insertId, respone.courseId)
                default:
                    throw WrongConvert()
                }
            }
    }
    
    func updateLink(insertId: Int, link: String) -> Observable<Void> {
        let input = API.UploadLinkInput(link: link, insertId: insertId)
        return API.shared.updateLink(input).map { _ in }
    }
}
