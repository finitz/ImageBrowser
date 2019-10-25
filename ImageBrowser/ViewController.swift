//
//  ViewController.swift
//  ImageBrowser
//
//  Created by 17 on 10/25/19.
//  Copyright © 2019 17. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupPageControl()

        self.view.addSubview(pageControl)
    }

    func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: 10.0*scrollView.bounds.size.width, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)

        var x = 0
        let y = 0
        let w = self.scrollView.frame.size.width
        let h = self.scrollView.frame.size.height
        for _ in 1...10 {
            let imgScrollView = ImageScrollView(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: w, height: h))
            imgScrollView.setImage(image: "image.jpg")
            self.scrollView.addSubview(imgScrollView)
            
            x = x + Int(w)
        }
    }

    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: view.bounds.size.height - CGFloat(50),
                                                  width: self.view.bounds.size.width,
                                                  height: 50.0))
        pageControl.numberOfPages = 10
        pageControl.addTarget(self,
                              action: #selector(changePage(sender:)),
                              for: .valueChanged)
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
    }

    @objc func changePage(sender:UIPageControl) {
        let offsetX = CGFloat(sender.currentPage) * CGFloat(scrollView.frame.size.width)
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / self.scrollView.frame.size.width)
        pageControl.currentPage = pageIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustZoomScales(around: pageControl.currentPage)
    }
    
    func adjustZoomScales(around index: Int) {
        if index == 0 {
            recoverZoomScale(at: index + 1)
        } else if index == scrollView.subviews.count {
            recoverZoomScale(at: index - 1)
        } else {
            recoverZoomScale(at: index - 1)
            recoverZoomScale(at: index + 1)
        }
    }
    
    func recoverZoomScale(at index: Int) {
        if let page = scrollView.subviews[index] as? ImageScrollView {
            page.zoomScale = page.minimumZoomScale
        }
    }

}





