//
//  AccountUseCase.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol AccountUseCaseType {
    func updateInfor(student: Student) -> Observable<Void>
    func getCurrentAuth() -> Observable<Student>
    func updateLocalData(student: Student)
    func loadModel() -> Observable<Void>
    func detectImage(images: [UIImage]) -> Observable<[[Double]]>
    func release() 
}

struct AccountUseCase: AccountUseCaseType {
    
    let facenet: FaceNet!
    let repo: UserRepositoryType
    
    func release() {
        facenet.clean()
    }
    
    func loadModel() -> Observable<Void> {
        return Observable<Void>.create { obser -> Disposable in
            if !self.facenet.loadedModel() {
                DispatchQueue.global().async {
                    self.facenet.load()
                    obser.onNext(())
                }
            } else {
                obser.onNext(())
            }
            return Disposables.create { }
        }
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
    
    func detectImage(images: [UIImage]) -> Observable<[[Double]]> {
        return Observable<Void>.create { obser -> Disposable in
            if !self.facenet.loadedModel() {
                DispatchQueue.global().async {
                    self.facenet.load()
                    obser.onNext(())
                }
            } else {
                obser.onNext(())
            }
            return Disposables.create { }
        }
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .map { _ in images.map { self.identifyFace(uiImage: $0) } }
        .do(onNext: {
            print($0)
        })
    }
    
    
    func identifyFace(uiImage: UIImage)-> [Double] {
        guard let cgImage = uiImage.cgImage else { return [] }
        guard let f = facenet.faceDetector.extractFaces(frame: CIImage(cgImage: cgImage)).first else { return [] }
        return facenet.run(image: f)
    }
    
    func updateInfor(student: Student) -> Observable<Void> {
        return repo.updateUserInfor(student: student)
    }
    
    func getCurrentAuth() -> Observable<Student> {
        guard let auth = AuthManager.authStudent else { return .empty() }
        return .just(auth)
    }
    
    func updateLocalData(student: Student) {
        AuthManager.shared.setAuthStudent(student)
    }
}
