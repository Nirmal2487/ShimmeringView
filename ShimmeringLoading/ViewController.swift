//
//  ViewController.swift
//  ShimmeringLoading
//
//  Created by Nirmal Patel on 2018-10-08.
//  Copyright © 2018 Nirmal Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var maskableSubviews: [UIView] = []
    var skeletonView = SkeletonView()
    
    
    private lazy var dummyLabelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.backgroundColor = .green
        label.text = "Dummy label one"
        
        return label
    }()
    
    private lazy var dummyLabelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.backgroundColor = .red
        label.text = "Dummy label two"
        
        return label
    }()
    
    private lazy var dummyImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imgView.backgroundColor = .blue
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skeletonView)
        view.addSubview(dummyImageView)
        skeletonView.addSubview(dummyLabelOne)
        skeletonView.addSubview(dummyLabelTwo)
        
        NSLayoutConstraint.activate([
            dummyLabelOne.leadingAnchor.constraint(equalTo: skeletonView.leadingAnchor, constant: 20),
            dummyLabelOne.trailingAnchor.constraint(lessThanOrEqualTo: skeletonView.trailingAnchor, constant: -20),
            dummyLabelOne.topAnchor.constraint(equalTo: skeletonView.topAnchor, constant: 40),
            dummyLabelOne.bottomAnchor.constraint(equalTo: dummyLabelTwo.topAnchor, constant: -10),
            
            dummyLabelTwo.leadingAnchor.constraint(equalTo: dummyLabelOne.leadingAnchor),
            dummyLabelTwo.trailingAnchor.constraint(lessThanOrEqualTo: dummyLabelOne.trailingAnchor, constant: -20),
            dummyLabelTwo.heightAnchor.constraint(equalToConstant: 20),
            
            dummyImageView.leadingAnchor.constraint(equalTo: skeletonView.leadingAnchor, constant: 20),
            dummyImageView.topAnchor.constraint(equalTo: skeletonView.bottomAnchor, constant: 10),
            
            skeletonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skeletonView.topAnchor.constraint(equalTo: view.topAnchor),
            skeletonView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        maskableSubviews = [dummyLabelOne, dummyLabelTwo]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skeletonView.setMaskingViews(maskableSubviews)
        skeletonView.startAnimating()
    }
}

extension UIView {
    
    /// Apply given views as masks
    ///
    /// - Parameter views: Views to apply as mask.
    /// ## Note: The view calling this function must have all the views in the given array as subviews.
    func setMaskingViews(_ views:[UIView]){
        
        let mutablePath = CGMutablePath()
        
        //Append path for each subview
        views.forEach { (view) in
            guard self.subviews.contains(view) else{
                fatalError("View:\(view) is not a subView of \(self). Therefore, it cannot be a masking view.")
            }
            //Check if ellipse
            if view.layer.cornerRadius == view.frame.size.height / 2, view.layer.masksToBounds{
                //Ellipse
                mutablePath.addEllipse(in: view.frame)
            }else{
                //Rect
                mutablePath.addRect(view.frame)
            }
        }
        
        //Create layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = mutablePath
        
        //Apply layer as a mask
        self.layer.mask = maskLayer
    }
}

