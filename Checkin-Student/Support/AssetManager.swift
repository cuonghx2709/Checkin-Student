//
//  AssetManager.swift
//  StudentManagement
//
//  Created by cuonghx on 10/9/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import Foundation
import Photos
import ImagePicker
import UIKit

open class AssetManager {
    
    public static func getImage(_ name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        var bundle = Bundle(for: AssetManager.self)
        
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/ImagePicker.bundle") {
            bundle = resourceBundle
        }
        
        return UIImage(named: name, in: bundle, compatibleWith: traitCollection) ?? UIImage()
    }
    
    public static func resolveAsset(_ asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280), shouldPreferLowRes: Bool = false, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = shouldPreferLowRes ? .fastFormat : .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
            if let info = info, info["PHImageFileUTIKey"] == nil {
                DispatchQueue.main.async(execute: {
                    completion(image)
                })
            }
        }
    }
    
    public static func resolveAssets(_ assets: [PHAsset], size: CGSize = CGSize.zero) -> [UIImage] {
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        
        requestOptions.deliveryMode = .highQualityFormat
        
        requestOptions.isNetworkAccessAllowed = true
        
        requestOptions.resizeMode = .exact
        
        if size == CGSize.zero{
            _ = PHImageManagerMaximumSize
        }
        
        
        var images = [UIImage]()
        
        for asset in assets {
            
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, _ in
                
                if let image = image {
                    images.append(image)
                }
            }
        }
        return images
    }
}
