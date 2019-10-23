//
//  FilterService.swift
//  LearnRxSwift
//
//  Created by Shabib Hossain on 2019-10-19.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

final class FilterService {
    
    private var context = CIContext()
    
    func applyfilter(to image: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: image) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage) -> ()) {
        guard let filter = CIFilter(name: "CICMYKHalftone") else {
            fatalError("dfhakjsd")
        }
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        if let source = CIImage(image: inputImage) {
            filter.setValue(source, forKey: kCIInputImageKey)
            if
                let outputImage = filter.outputImage,
                let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
