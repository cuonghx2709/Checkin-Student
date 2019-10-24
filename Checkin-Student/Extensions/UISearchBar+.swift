//
//  UISearchBar+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UISearchBar {
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
