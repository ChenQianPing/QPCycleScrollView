//
//  QPCycleScrollView.swift
//  QPCycleScrollViewDemo
//
//  Created by ChenQianPing on 16/11/23.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import UIKit

// 自定义代理方法
protocol QPCycleScrollViewDelegate:NSObjectProtocol {
    func adLoopView(_ adLoopView:QPCycleScrollView ,IconClick index:NSInteger)
}

class QPCycleScrollView : UIView {
    
    fileprivate var pageControl : UIPageControl?
    fileprivate var imageScrollView : UIScrollView?
    fileprivate var currentPage: NSInteger?
    fileprivate var images: NSArray?
    fileprivate var autoPlay : Bool?
    fileprivate var isFromNet : Bool?
    fileprivate var delay : TimeInterval?
    fileprivate var currentImgs = NSMutableArray()
    fileprivate var timer :Timer?
    
    var delegate:QPCycleScrollViewDelegate?
    
    // 重写get方法
    fileprivate var currentImages :NSMutableArray? {
        get {
            currentImgs.removeAllObjects()
            
            let count = self.images!.count
            
            var i = NSInteger(self.currentPage!+count-1)%count
            currentImgs.add(self.images![i])
            currentImgs.add(self.images![self.currentPage!])
            
            i = NSInteger(self.currentPage!+1)%count
            currentImgs.add(self.images![i])
            
            return currentImgs
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 构造器方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 便利构造方法,通过调用指定构造方法,提供默认值来简化构造方法实现
    convenience init(frame:CGRect ,images:NSArray, autoPlay:Bool, delay:TimeInterval, isFromNet:Bool) {
        self.init(frame: frame)
        self.images = images;
        self.autoPlay = autoPlay
        self.isFromNet = isFromNet
        self.delay = delay
        self.currentPage = 0
        
        createImageScrollView()
        createPageView()
        
        if images.count<2 {
            self.autoPlay = false
            pageControl?.isHidden = true
        }
        
        if self.autoPlay == true {
            startAutoPlay()
        }
        
    }
    
    fileprivate func createImageScrollView(){
        if images?.count == 0 {
            return
        }
        
        imageScrollView = UIScrollView(frame: self.bounds)
        imageScrollView?.showsHorizontalScrollIndicator = false
        imageScrollView?.showsVerticalScrollIndicator = false
        imageScrollView?.bounces = true
        imageScrollView?.delegate = self
        imageScrollView?.contentSize = CGSize(width: self.bounds.width * 3, height: 0)
        imageScrollView?.contentOffset = CGPoint(x: self.frame.width, y: 0)
        imageScrollView?.isPagingEnabled = true
        self.addSubview(imageScrollView!)
        
        for index in 0..<3 {
            let imageView = UIImageView(frame: CGRect(x: self.bounds.width * CGFloat(index), y: 0, width: self.bounds.width, height: self.bounds.height))
            
            imageView.isUserInteractionEnabled = true
            
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QPCycleScrollView.imageViewClick)))
            
            
            if self.isFromNet == true {
                
            }
            else {
                imageView.image = UIImage(named: self.currentImages![index] as! String);
            }
            imageScrollView?.addSubview(imageView)
        }
        
    }
    
    fileprivate func createPageView() {
        if images?.count == 0 {
            return
        }
        let pageW: CGFloat = 80
        let pageH: CGFloat = 25
        let pageX: CGFloat = self.bounds.width - pageW
        let pageY: CGFloat = self.bounds.height - pageH
        
        pageControl = UIPageControl(frame: CGRect(x: pageX, y: pageY, width: pageW, height: pageH))
        pageControl?.numberOfPages = images!.count
        pageControl?.currentPage = 0
        pageControl?.isUserInteractionEnabled = false
        self.addSubview(pageControl!)
    }
    
    fileprivate func startAutoPlay() {
        
        timer = Timer.scheduledTimer(timeInterval: delay!, target: self, selector: #selector(QPCycleScrollView.nextPage), userInfo: nil, repeats: true)
        
        // 修改self.timer的优先级与控件一样
        let runloop:RunLoop  = RunLoop.current           // 获取当前的消息循环对象
        runloop.add(self.timer!, forMode: RunLoopMode.commonModes)  // 改变self.timer对象的优先级
    }
    
    fileprivate func refreshImages() {
        for i in 0..<imageScrollView!.subviews.count {
            let imageView = imageScrollView!.subviews[i] as! UIImageView
            if self.isFromNet == true {
                
            }
            else{
                imageView.image = UIImage(named: self.currentImages![i] as! String);
            }
        }
        
        imageScrollView!.contentOffset = CGPoint(x: self.frame.width, y: 0)
    }
    
    func nextPage() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(QPCycleScrollView.nextPage), object: nil)
        imageScrollView!.setContentOffset(CGPoint(x: 2 * self.frame.width, y: 0), animated: true)
        self.perform(#selector(QPCycleScrollView.nextPage), with: nil, afterDelay: delay!)
        
    }
    
    func imageViewClick() {
        
        if self.delegate != nil {
            self.delegate!.adLoopView(self, IconClick: currentPage!)
        }
    }
    
}

extension QPCycleScrollView : UIScrollViewDelegate {
    
    // scrollview先是执行停止拖住的代理,然后在执行减速停止的代理(DidEndDecelerating)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 设置UIScrollView的contentOffset等于新的偏移的值
        scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: true)
    }
    
    // 实现UIScrollView的滚动方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = self.frame.width
        
        if offsetX >= 2*width {
            currentPage = (currentPage!+1) % self.images!.count
            pageControl!.currentPage = currentPage!
            refreshImages()
        }
        if offsetX <= 0 {
            currentPage = (currentPage!+self.images!.count-1) % self.images!.count
            pageControl!.currentPage = currentPage!
            refreshImages()
        }
    }
    
    // 即将开始拖拽的方法
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 调用invalidate一旦停止计时器,那么这个计时器就不可再重用了,下次必须重新创建一个新的计时器对象.
        self.timer?.invalidate()
        // 因为当调用完毕invalidate方法以后,这个计时器对象就已经废了,无法重用了,所以可以直接将self.timer设置为nil
        self.timer = nil
    }
    
    // 拖拽完毕的方法
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 重新启动计时器
        timer = Timer.scheduledTimer(timeInterval: delay!, target: self, selector: #selector(QPCycleScrollView.nextPage), userInfo: nil, repeats: true)
        
        // 再次修改一下新创建的timer的优先级
        let runloop:RunLoop  = RunLoop.current
        runloop.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
}

