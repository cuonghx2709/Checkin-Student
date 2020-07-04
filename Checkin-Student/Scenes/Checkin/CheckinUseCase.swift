//
//  File.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import FirebaseStorage

protocol CheckinUseCaseType {
    func detectImage(image: CIImage) -> Observable<[Double]>
    func getCurrentVector() -> Observable<[[Double]]>
    func checkin(studentId: Int, latitude: Double, longitude: Double) -> Observable<(Int, Int)>
    func uploadImage(image: CIImage, insertId: Int, courseId: Int) -> Observable<Void>
    func release()
}

struct CheckinUseCase: CheckinUseCaseType {
    
    let facenet: FaceNet!
    let repo: CheckinRepositoryType!
    
    func release() {
        facenet.clean()
    }
    
    func detectImage(image: CIImage) -> Observable<[Double]> {
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
        .map { _ -> [Double] in
            return self.identifyFace(uiImage: image)
        }
    }
    
    private func convert(cmage: CIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(cmage, from: cmage.extent) else { return nil }
        let image: UIImage = UIImage(cgImage: cgImage)
        return image
    }
    
    func identifyFace(uiImage: CIImage) -> [Double] {
        guard let f = facenet.faceDetector.extractFaces(frame: uiImage).first else { return [] }
        return facenet.run(image: f)
    }
    
    func getCurrentVector() -> Observable<[[Double]]>{
        return Observable.create { obser -> Disposable in
            guard let data = AuthManager.authStudent?.vectors.data(using: .utf8) else {
                obser.onError(UpdateImageError())
                return Disposables.create()
            }
            var vectors: [[Double]] = []
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let arr = json as? [[Double]] {
                    vectors = arr
                }
            } catch {
                obser.onError(UpdateImageError())
            }
            obser.onNext(vectors)
            return Disposables.create()
        }
    }
    
    func checkin(studentId: Int, latitude: Double, longitude: Double) -> Observable<(Int, Int)> {
        return repo.checkin(studentId: studentId, latitude: latitude, longitude: longitude)
    }
    
    func uploadImage(image: CIImage, insertId: Int, courseId: Int) -> Observable<Void> {
        return Observable<String>.create { obser -> Disposable in
            let studentID = AuthManager.authStudent?.id ?? 0
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let mountainImagesRef = storageRef.child("course_\(courseId)/\(studentID)_\(components.day!)-\(components.month!).jpg")
            let image = self.convert(cmage: image)
            guard let dataTest = image?.jpegData(compressionQuality: 0.5) else {
                obser.onError(UpdateImageError())
                return Disposables.create()
            }
            let uploadTask = mountainImagesRef.putData(dataTest, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    return
                }
                mountainImagesRef.downloadURL { url, error in
                    if let error = error {
                        print(error)
                    } else if let link = url?.absoluteString {
                        obser.onNext(link)
                    }
                }
            }
            uploadTask.resume()
            
            return Disposables.create()
        }
        .flatMapLatest { link in
            self.updateLink(link: link, inserId: insertId)
        }
    }
    
    func updateLink(link: String, inserId: Int) -> Observable<Void> {
        return repo.updateLink(insertId: inserId, link: link)
    }
}
