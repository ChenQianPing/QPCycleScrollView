# QPCycleScrollView
Swift Picture carousel view

# Example Usage
- **createQPCycleScrollView**
```
func createQPCycleScrollView() {
        
    let frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 130)

    let imageView = ["banner03","banner05","banner06","banner07"]
    let loopView = QPCycleScrollView(frame: frame, images: imageView as NSArray, autoPlay: true, delay: 3, isFromNet: false)
    loopView.delegate = self
    view.addSubview(loopView)
}
```

- **extension ViewController**

```
extension ViewController:QPCycleScrollViewDelegate {
    func adLoopView(_ adLoopView: QPCycleScrollView, IconClick index: NSInteger) {
        print(index)
    }
}
```

# Cocoapods

Add pod ```'QPCycleScrollView', '~> 1.0.1'``` to your Podfile
Run ```pod install``` or ```pod update```

# Contributing

- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a new demand, also open an issue.

# MIT License

QPCycleScrollView is available under the MIT license. See the LICENSE file for more info.
