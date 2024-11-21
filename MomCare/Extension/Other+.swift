//
//  Other+.swift
//  MomCare
//
//  Created by Nam Ngây on 20/12/2021.
//

import Foundation
import UIKit
import LocalAuthentication

func saveImage(imageName: String, image: UIImage?, type: UserChoice) -> String {
    if let image = image {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
        
        let fileName = imageName
        var quality = 1
        if type == .mom {
            quality = 0
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: CGFloat(quality)) else { return ""}
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        return fileName
    }
    return ""
}

func loadImageFromDiskWith(fileName: String, completion: @escaping (UIImage)-> ()) {
    DispatchQueue.global(qos: .background).async {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                completion(image)
            }
        }
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
