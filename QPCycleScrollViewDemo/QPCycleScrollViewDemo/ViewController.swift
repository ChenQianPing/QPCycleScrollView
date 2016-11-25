//
//  ViewController.swift
//  QPCycleScrollViewDemo
//
//  Created by ChenQianPing on 16/11/26.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createQPCycleScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createQPCycleScrollView() {
        
        let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 130)
        
        let imageView = ["banner03","banner05","banner06","banner07"]
        let loopView = QPCycleScrollView(frame: frame, images: imageView as NSArray, autoPlay: true, delay: 3, isFromNet: false)
        loopView.delegate = self
        view.addSubview(loopView)
    }


}

extension ViewController:QPCycleScrollViewDelegate {
    func adLoopView(_ adLoopView: QPCycleScrollView, IconClick index: NSInteger) {
        print(index)
    }
}

