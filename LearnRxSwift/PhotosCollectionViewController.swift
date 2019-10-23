//
//  PhotosCollectionViewController.swift
//  LearnRxSwift
//
//  Created by Shabib Hossain on 2019-10-19.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import UIKit
import Photos
import RxSwift

final class PhotosCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "PhotoCollectionViewCell"
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assests = PHAsset.fetchAssets(with: .image, options: nil)
                assests.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("no cell")
        }
        
        let asset = images[indexPath.row]
        PHImageManager.default().requestImage(for: asset, targetSize: cell.photoImageView.bounds.size, contentMode: .aspectFill, options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: self.view.bounds.size, contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            guard
                let image = image,
                let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            if !isDegradedImage {
                self?.selectedPhotoSubject.onNext(image)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

}
