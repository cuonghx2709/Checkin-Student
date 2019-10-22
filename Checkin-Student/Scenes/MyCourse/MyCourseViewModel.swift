//
//  MyCourseViewModel.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct MyCourseViewModel {
    let navigator: MyCourseNavigatorType
    let usecase: MyCourseUseCaseType
}

extension MyCourseViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
