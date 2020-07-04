//
//  AccountViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ImagePicker

final class AccountViewController: UIViewController, BindableType {
    
    var viewModel: AccountViewModel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var birthDayTextField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    
    private let isUpdate = Variable<Bool>(false)
    private var imageViews: [UIImageView] = []
    private var updateImages = PublishSubject<[UIImage]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupViews()
    }
    
    private func setupViews() {
        guard let auth = AuthManager.authStudent else { return }
        nameTextField.text = auth.name
        birthDayTextField.text = auth.birthDay
        birthDayTextField.delegate = self
        birthDayTextField.setInputViewDatePicker(target: self, selector: #selector(self.tapDone))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        configViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationController?.navigationBar.isHidden ?? false {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bindViewModel() {
        logoutButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.handlerLogoutButton()
        })
            .disposed(by: rx.disposeBag)
        
        isUpdate.asDriver().drive(onNext: { [weak self] isUpdate in
            if isUpdate {
                self?.logoutButton.setTitle(Constants.Title.update, for: .normal)
                self?.nameTextField.isEnabled = true
                self?.birthDayTextField.isEnabled = true
                self?.imageView.isUserInteractionEnabled = true
                self?.nameTextField.becomeFirstResponder()
                self?.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = Constants.Title.cancel
            } else {
                self?.logoutButton.setTitle(Constants.Title.logout, for: .normal)
                self?.nameTextField.isEnabled = false
                self?.birthDayTextField.isEnabled = false
                self?.imageView.isUserInteractionEnabled = false
                self?.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = Constants.Title.update
            }
        }).disposed(by: rx.disposeBag)
        
        imageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.setupImagePicker()
            })
            .disposed(by: rx.disposeBag)
        
        let updateTrigger = logoutButton.rx.tap
            .asDriverOnErrorJustComplete()
            .filter { [weak self] _ in self?.isUpdate.value ?? false }
            .map { [weak self] _ in
                Student().with {
                    $0.name = self?.nameTextField.text ?? ""
                    $0.birthDay = self?.birthDayTextField.text ?? ""
                    $0.id = AuthManager.authStudent?.id ?? 0
                }
            }
        
        let input = AccountViewModel.Input(
            updateTrigger: updateTrigger,
            loadInforTrigger: rx.viewWillAppearTrigger,
            loadModelTrigger: rx.viewWillAppearTrigger,
            updateImagesTrigger: updateImages.asDriverOnErrorJustComplete(),
            releaseTrigger: rx.viewWillDisappearTrigger)
        
        let output = viewModel.transform(input)
        
        output.error.drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.isLoading.drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.updated.drive(updateInforBinder)
            .disposed(by: rx.disposeBag)
        
        output.changeImages
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.modelLoaded.drive().disposed(by: rx.disposeBag)
        
        output.released.drive().disposed(by: rx.disposeBag)
    }
    
    private func setupImagePicker() {
        guard isUpdate.value else { return }
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 3
        imagePicker.delegate = self
        imagePicker.galleryView.isHidden = true
        imagePicker.startOnFrontCamera = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func configViews() {
        var title = ""
        if isUpdate.value {
            title = Constants.Title.cancel
        } else {
            title = Constants.Title.update
        }
        
        let editButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(updateButton))
        navigationController?.navigationBar.topItem?.setRightBarButton(editButton, animated: true)
        navigationController?.navigationBar.topItem?.title = Constants.Title.myAccount
        
    }
    
    @objc private func updateButton() {
        isUpdate.value.toggle()
    }
    
    @objc private func tapDone() {
        if let datePicker = birthDayTextField.inputView as? UIDatePicker {
            birthDayTextField.text = datePicker.date.toString(dateFormat: "dd/MM/yyyy")
        }
        birthDayTextField.resignFirstResponder()
    }
    
    func handlerLogoutButton() {
        guard !isUpdate.value else { return }
        AuthManager.shared.logOut()
        let assembler = DefaultAssembler()
        
        let vc: LoginViewController = assembler.resolve(navController: navigationController!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleImage(images: [UIImage]) {
        imageViews.forEach {
            $0.removeFromSuperview()
        }
        if images.isEmpty {
            self.imageView.image = UIImage(named: "pickImage")
        } else {
            self.imageView.image = nil
        }
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(frame: self.imageView.frame.with {
                if images.count == 1 {
                    $0.origin.x += 0
                } else if images.count == 2 {
                    $0.origin.x -= CGFloat(80 * Double(0.5 * Double(index)))
                } else {
                    $0.origin.x -= CGFloat(80 * (index - 1 ))
                }
                $0.origin.y -= CGFloat(10 * (index))
            })
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.view.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
}

extension AccountViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("1")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        handleImage(images: images)
        let imgs = AssetManager.resolveAssets(imagePicker.stack.assets, size: CGSize(width: 720, height: 960))
        var imageDetect = [UIImage]()
        
        for i in 0..<images.count {
            let image = images[i]
            if image.size.width / image.size.height == 3/4 {
                imageDetect.append(imgs[i])
            } else {
                imageDetect.append(image)
            }
        }
        imagePicker.dismiss(animated: true) { [weak self] in
            self?.updateImages.onNext(imageDetect)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController {
    var updateInforBinder: Binder<Student> {
        return Binder<Student>(self) { vc, student in
            vc.nameTextField.text = student.name
            vc.birthDayTextField.text = student.birthDay
        }
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension AccountViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
