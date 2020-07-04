//
//  CheckinViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

fileprivate var framesQueue : DispatchQueue!
private var CapturingStillImageContext = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 128)
private var SessionRunningContext = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 128)

// Session management
private var sessionQueue: DispatchQueue!
private var session: AVCaptureSession!
private var videoDeviceInput: AVCaptureDeviceInput!
private var stillImageOutput: AVCapturePhotoOutput!//AVCaptureStillImageOutput!
private var videoDataOutput: AVCaptureVideoDataOutput!

private var frontCam = true

enum AVCamSetupResult: Int {
    case success
    case cameraNotAuthorized
    case sessionConfigurationFailed
}

// Utils
private var setupResult: AVCamSetupResult = .success
private var sessionRunning = false
private var backgroundRecordingID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
private var dataQueueSuspended = false

private var worldView = WorldView()


final class CheckinViewController: UIViewController, BindableType {
    
    var viewModel: CheckinViewModel!
    
    private let imageSuject = PublishSubject<CIImage>()
    private let currentLocation = PublishSubject<(Double, Double)>()
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager().then {
            $0.requestAlwaysAuthorization()
            $0.requestWhenInUseAuthorization()
        }
        return locationManager
    }()
    
    deinit {
        logDeinit()
    }
    
    //MARK: - Orientation
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orientCam()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCam()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCam()
    }
    
     private func configLocation() {
           if CLLocationManager.locationServicesEnabled() {
               locationManager.do {
                   $0.delegate = self
                   $0.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                   $0.startUpdatingLocation()
               }
           } else {
            showError(message: "GPS của bạn đã bị denied, Hãy cho phép GPS khi xử dụng app")
           }
       }
    
    
    // MARK: - Methods
    func bindViewModel() {
        let input = CheckinViewModel.Input(
            imageFrameTrigger: imageSuject.asDriverOnErrorJustComplete(),
            loadTrigger: .just(()),
            location: currentLocation.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)
        
        output.detectedImage
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.currentVector
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.error.drive(rx.error)
            .disposed(by: rx.disposeBag)
    }
    
    private func configView() {
        
    }
    
    
    @IBAction func handleCloseButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - ConfigCamera
extension CheckinViewController {
    
    @objc class func deviceWithMediaType(
        _ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices =  AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType(rawValue: mediaType), position: position).devices
        
        guard var captureDevice = devices.first else { return nil }
        
        for device in devices as [AVCaptureDevice] {
            if device.position == position {
                captureDevice = device
                break
            }
        }
        
        return captureDevice
    }
    
    @objc func setupCam() {
        do {
            worldView = WorldView(frame: view.bounds)
            worldView.backgroundColor = UIColor.black
            view.addSubview(worldView)
            view.sendSubviewToBack(worldView)
        }
        
        // create AVCaptureSession
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // setup the world view
        worldView.session = session
        
        sessionQueue = DispatchQueue(label: "session queue", attributes: [])
        framesQueue = DispatchQueue(label: "framesQueue", attributes: [])
        
        setupResult = .success
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if !granted {
                    setupResult = .cameraNotAuthorized
                }
                sessionQueue.resume()
            }
        default:
            setupResult = .cameraNotAuthorized
        }
        
        guard setupResult == .success else { return }
        
        backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
        
        guard let camera =  CheckinViewController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: frontCam ? .front : .back) else { return }
        let vidInput: AVCaptureDeviceInput!
        do {
            vidInput = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError {
            vidInput = nil
            NSLog("Could not create video device input: %@", error)
        } catch _ {
            fatalError()
        }
        
        session.beginConfiguration()
        
        if session.canAddInput(vidInput) {
            session.addInput(vidInput)
            videoDeviceInput = vidInput
            
            DispatchQueue.main.async{
                let statusBarOrientation = UIApplication.shared.statusBarOrientation
                var initialVideoOrientation = AVCaptureVideoOrientation.portrait
                if statusBarOrientation != .unknown {
                    initialVideoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue)!
                }
                
                let previewLayer = worldView.layer as! AVCaptureVideoPreviewLayer
                previewLayer.connection?.videoOrientation = initialVideoOrientation
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                
            }
        } else {
            NSLog("Could not add video device input to the session")
            setupResult = .sessionConfigurationFailed
        }
        
//        //videoData
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]

        videoDataOutput.alwaysDiscardsLateVideoFrames = true

        framesQueue.suspend();
        dataQueueSuspended = true
        videoDataOutput.setSampleBufferDelegate(self, queue:framesQueue )

        if session .canAddOutput(videoDataOutput) { session .addOutput(videoDataOutput) }

        //orient frames to initial application orientation
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation != .unknown {
            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue)!
        }
        //Still Image
        let still = AVCapturePhotoOutput()
        if session.canAddOutput(still) {
            session.addOutput(still)
            stillImageOutput = still
        } else {
            setupResult = .sessionConfigurationFailed
        }
        
        session.commitConfiguration()
        
        //start cam
        if setupResult == .success {
            session.startRunning()//blocking call
            sessionRunning = session.isRunning
            resumeFrames()
        }
        
    }
    
    @objc func stopCam() {
        sessionQueue.async {
            if setupResult == .success {
                session.stopRunning()
                sessionRunning = false
            }
        }
        
    }
    
    @objc func resumeFrames() {
        sessionQueue.async{
            if dataQueueSuspended { framesQueue.resume() }
            dataQueueSuspended = false
        }
        
    }
    
    @objc func orientCam() {
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation.isPortrait || deviceOrientation.isLandscape {
            let previewLayer = worldView.layer as! AVCaptureVideoPreviewLayer
            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: deviceOrientation.rawValue)!
            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = AVCaptureVideoOrientation(rawValue: deviceOrientation.rawValue)!
        }
    }
    
}

extension CheckinViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension CheckinViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let frameImage = CIImage(cvPixelBuffer: buffer)
        
        imageSuject.onNext(frameImage)
        
    }
}

class WorldView: UIView {
    
    override class var layerClass : AnyClass {
        
        return AVCaptureVideoPreviewLayer.self
    }
    
    @objc var session : AVCaptureSession {
        
        get {
            
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            return previewLayer.session!
        }
        
        set (session) {
            
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            previewLayer.session = session
            
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CheckinViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation.onNext((locValue.latitude, locValue.longitude))
        print(locValue.latitude)
        print(locValue.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            showError(message: "GPS của bạn đã bị denied, Hãy cho phép GPS khi xử dụng app")
        }
    }
}

