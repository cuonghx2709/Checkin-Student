//
//  MainViewModel.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct MainViewModel {
    var usecase: MainUseCaseType
    var navigator: MainNavigatorType
}

extension MainViewModel: ViewModelType {
    struct Input {
        var checkinTrigger: Driver<Void>
    }
    
    struct Output {
        let redirect: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let toCheckinVC = input.checkinTrigger
            .do(onNext: { _ in
                self.navigator.toCheckin()
            })
        
        let redirect = Driver.merge(toCheckinVC)
        
        return Output(redirect: redirect)
    }
}
