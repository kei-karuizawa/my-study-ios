import UIKit
import FSPagerView
import SnapKit

class ViewController: UIViewController, FSPagerViewDataSource,FSPagerViewDelegate {
    
    var imageNames = [
        "testimage",
        "testimage",
        "testimage",
        "testimage",
        "testimage",
        "testimage",
        "testimage",
        "testimage",
    ]
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
//        let scrollableText = ScrollableText()
//        scrollableText.backgroundColor = .red
//        view.addSubview(scrollableText)
//        scrollableText.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.height.equalTo(200)
//        }
        
        // 创建 DropDownView
//        let dropDownView = SelectableButton(frame: CGRect(x: 50, y: 100, width: 200, height: 300))
//        dropDownView.configure(buttonTitle: "Show Options", items: ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"])
//        view.addSubview(dropDownView)
        
//        // 模拟文本输入
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            scrollableText.appendText("Hello")
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            scrollableText.appendText(" World!")
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            scrollableText.appendText(" This is a sliding text view.sadasdas的打算发烧的发生的发生的撒旦法说的发")
//        }
        
        // 创建 CarouselView
//        let carouselView = CarouselView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        let pageView = FSPagerView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        pageView.transformer = FSPagerViewTransformer(type: .linear)
        pageView.delegate = self
        pageView.dataSource = self
        pageView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
//        pageView.itemSize = pageView.frame.size.applying(transform)
        pageView.isInfinite = true
        pageView.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: 180)
//        pageView.decelerationDistance = FSPagerView.automaticDistance
//        pageView.interitemSpacing = 100
//        pageView.decelerationDistance = 100
        view.addSubview(pageView)
    }
}
