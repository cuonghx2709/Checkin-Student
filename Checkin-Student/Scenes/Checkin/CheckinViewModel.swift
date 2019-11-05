//
//  CheckinViewModel.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct CheckinViewModel {
    let usecase: CheckinUseCaseType
    let navigator: CheckinNavigatorType
}

extension CheckinViewModel: ViewModelType {
    struct Input {
        var imageFrameTrigger: Driver<CIImage>
    }
    
    struct Output {
        var detectedImage: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let detectedImage = input.imageFrameTrigger
        
        return Output(detectedImage: detectedImage.mapToVoid())
    }
}
