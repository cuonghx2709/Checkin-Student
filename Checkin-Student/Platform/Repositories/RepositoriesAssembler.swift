//
//  RepositoriesAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/31/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol RepositoriesAssembler {
    func resolve() -> UserRepositoryType
    func resolve() -> CourseRepositoryType
    func resolve() -> CheckinRepositoryType
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> UserRepositoryType {
        return UserRepository()
    }
    
    func resolve() -> CourseRepositoryType {
        return CourseRepository()
    }
    
    func resolve() -> CheckinRepositoryType {
        return CheckinRepository()
    }
}
