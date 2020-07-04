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
        var loadTrigger: Driver<Void>
        var location: Driver<(Double, Double)>
    }
    
    struct Output {
        var detectedImage: Driver<Void>
        var currentVector: Driver<Void>
        var error: Driver<Error>
    }
    
    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let lockPublish = Variable<Bool>(true)
        let currentImageChecking = PublishSubject<CIImage>()
        
        let loadCurrentVector = input.loadTrigger
            .flatMapLatest { _ in
                return self.usecase.getCurrentVector()
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let detectedImage = input.imageFrameTrigger
            .filter { _ in lockPublish.value }
            .do(onNext: { image in
                currentImageChecking.onNext(image)
                lockPublish.value = false
            })
            .flatMapLatest { image in
                self.usecase.detectImage(image: image).asDriverOnErrorJustComplete()
            }
            .withLatestFrom(loadCurrentVector) { vectorDetected, currentVectors -> Double in
                var distance: Double = 10
                currentVectors.forEach { vector in
                    if vector.count > 0 {
                        let dist = Utils.l2distance(vectorDetected, vector)
                        if dist < distance, dist != 0 {
                            distance = dist
                        }
                    }
                }
                return distance
            }
            .do(onNext: { value in
                print(value)
                if value > 1.0 {
                    lockPublish.value = true
                }
            })
            .filter { $0 < 1.0 }
            .withLatestFrom(input.location)
            .flatMapLatest { location  -> Driver<(Int, Int)> in
                guard let student = AuthManager.authStudent else {
                    return .empty()
                }
                return self.usecase
                    .checkin(studentId: student.id, latitude: location.0, longitude: location.1)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .withLatestFrom(currentImageChecking.asDriverOnErrorJustComplete()) { checkin, image -> (Int, Int, CIImage) in
                return (checkin.0, checkin.1, image)
            }
            .flatMapLatest { values -> Driver<Void> in
                self.usecase.uploadImage(image: values.2, insertId: values.0, courseId: values.1)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { _ in
                self.navigator.showToastCheckinSuccess()
            })
        
        return Output(
            detectedImage: detectedImage.mapToVoid(),
            currentVector: loadCurrentVector.mapToVoid(),
            error: errorTracker.asDriver()
        )
    }
}
