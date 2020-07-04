//
//  AccountViewModel.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct AccountViewModel {
    let navigator: AccountNavigatorType
    let usecase: AccountUseCaseType
}

extension AccountViewModel: ViewModelType {
    struct Input {
        let updateTrigger: Driver<Student>
        let loadInforTrigger: Driver<Void>
        let loadModelTrigger: Driver<Void>
        let updateImagesTrigger: Driver<[UIImage]>
        let releaseTrigger: Driver<Void>
    }
    
    struct Output {
        let changeImages: Driver<Void>
        let updated: Driver<Student>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let modelLoaded: Driver<Void>
        let released: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let imagesVector = Variable<String>("")
        let publishImages = PublishSubject<Bool>()
        
        let changeImages = input.updateImagesTrigger
            .do(onNext: { _ in
                publishImages.onNext(true)
            })
            .flatMapLatest {
                self.usecase.detectImage(images: $0)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { images in
                publishImages.onNext(false)
                guard images.map({ $0.count > 0 }).contains(true) else {
                    self.navigator.showImageWrong()
                    return
                }
                imagesVector.value = images.map { $0.map { $0.rounded(toPlaces: 7) } }.description
            })
        
        let updated = input.updateTrigger
            .filter { _ in !imagesVector.value.isEmpty }
            .do(onNext: { _ in
                if imagesVector.value.isEmpty {
                    self.navigator.showImageWrong()
                }
            })
            .withLatestFrom(imagesVector.asDriver()) { student, imagesVector in
                student.with { $0.vectors = imagesVector }
            }
            .flatMapLatest {
                self.usecase.updateInfor(student: $0)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .withLatestFrom(input.updateTrigger)
        .withLatestFrom(imagesVector.asDriver()) { student, imagesVector in
                student.with { $0.vectors = imagesVector }
            }
            .do(onNext: { _ in
                self.navigator.showToastUpdateSuccess()
            })
        
        let loadInfor = input.loadInforTrigger
            .flatMapLatest {
                self.usecase.getCurrentAuth().asDriverOnErrorJustComplete()
            }
            .do(onNext: { student in
                imagesVector.value = student.vectors
            })
        
        let userUpdatedInfor = Driver.merge(updated, loadInfor)
            .do(onNext: { student in
                self.usecase.updateLocalData(student: student)
            })
        
        let loadModel = input.loadModelTrigger
            .flatMapLatest { _ in
                self.usecase.loadModel()
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let release = input.releaseTrigger
            .do(onNext: { _ in
                self.usecase.release()
            })
        
        return Output(
            changeImages: changeImages.mapToVoid(),
            updated: userUpdatedInfor,
            error: errorTracker.asDriver(),
            isLoading: Driver.merge(activityIndicator.asDriver(), publishImages.asDriverOnErrorJustComplete()),
            modelLoaded: loadModel.mapToVoid(),
            released: release.asDriver()
        )
    }
}
