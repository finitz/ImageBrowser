//
//  ImageScrollView.swift
//  ImageBrowser
//
//  Created by 17 on 10/25/19.
//  Copyright © 2019 17. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    var zoomImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 3
                
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        zoomImage = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        centerContent()
        
        self.setupRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(tap:)))
        tap.numberOfTapsRequired = 2
        tap.isEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleDoubleTap(tap: UITapGestureRecognizer) {
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let location = tap.location(in: zoomImage)
            let rect = CGRect(x: location.x, y: location.y, width: 1, height: 1)
            zoom(to: rect, animated: true)
        }
    }
    
    func setImage(image: String) {
        zoomImage.image = UIImage(named: image)
        zoomImage.contentMode = .scaleAspectFit
        zoomImage.isUserInteractionEnabled = true
        self.contentSize = zoomImage.bounds.size
        
        centerContent()
        self.addSubview(zoomImage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImage
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }

    func centerContent() {
        let imageViewSize = zoomImage.frame.size

        var vertical:CGFloat = 0, horizontal:CGFloat = 0
        if imageViewSize.width < self.bounds.size.width  {
            horizontal = (self.bounds.size.width - imageViewSize.width) / 2.0
        }

        if imageViewSize.height < self.bounds.size.height  {
            vertical = (self.bounds.size.height - imageViewSize.height) / 2.0
        }

        self.contentInset = UIEdgeInsets(top: vertical,
                                               left: horizontal,
                                               bottom: vertical,
                                               right: horizontal)
    }
        
}
