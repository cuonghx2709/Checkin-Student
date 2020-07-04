//
//  UITextField+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 3/21/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

extension UITextField {
    func setMarginLeft(_ margin: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 0))
        leftViewMode = .always
    }
    
    func setNextResponder(_ nextResponder: UIResponder?, completion: (() -> Void)? = nil) {
        returnKeyType = nextResponder != nil ? .next : .done
        rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self, weak nextResponder] in
                if let nextResponder = nextResponder {
                    nextResponder.becomeFirstResponder()
                } else {
                    completion?()
                    self?.resignFirstResponder()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func left(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).then {
                $0.contentMode = .scaleAspectFit
                $0.image = image
                $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = color
            }
            leftView = imageView
        }
    }
    
    func right(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).then {
                $0.contentMode = .scaleAspectFit
                $0.image = image
                $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = color
            }
            rightView = imageView
        }
    }
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.locale = Locale(identifier: "vi")
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Huỷ", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
