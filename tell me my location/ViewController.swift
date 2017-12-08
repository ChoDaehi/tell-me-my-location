//
//  ViewController.swift
//  tell me my location
//
//  Created by 조대희 on 2017. 12. 5..
//  Copyright © 2017년 AsiaQuest.inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    ScrollView.contentSize = CGSize(width: 2000, height: 4000)
    
    
    }
    override func viewDidAppear(_ animated: Bool) {
        ScrollView.delegate = self
        ScrollView.maximumZoomScale = 8.0
        ScrollView.minimumZoomScale = 1.0
    }
    func viewForZoom(scrollView: UIScrollView) -> UIView? {
        return self.map
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

