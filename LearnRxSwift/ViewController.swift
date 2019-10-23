//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by Shabib Hossain on 2019-10-19.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navC = segue.destination as? UINavigationController,
            let photoVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("nothing")
        }
        photoVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        imageView.image = image
        filterButton.isHidden = false
    }
    
    @IBAction private func applyFilterAction() {
        guard let sourceImage = imageView.image else {
            return
        }
        FilterService().applyfilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
            }
            }).disposed(by: disposeBag)
    }
}

