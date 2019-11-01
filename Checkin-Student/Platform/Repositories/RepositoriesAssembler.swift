//
//  RepositoriesAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/31/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol RepositoriesAssembler {
    func resolve() -> UserRepositoryType
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> UserRepositoryType {
        return UserRepository()
    }
}
