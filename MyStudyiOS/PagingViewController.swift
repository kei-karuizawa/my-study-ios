import UIKit

class PagingViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var data: [Int] = Array(0..<1000) // 使用大数组模拟无限滚动
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true // 禁用系统分页
//        collectionView.decelerationRate = .fast // 快速滑动
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // 初始滚动到中间位置
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.data.count/2, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: - CollectionView DataSource & Delegate
extension PagingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.label.text = "\(data[indexPath.item])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 200)
    }
    
    // 手动处理分页逻辑
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = collectionView.bounds.width
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.pointee.x
        let newTargetOffset = (targetOffset + currentOffset) / 2.0
        
        let page = round(newTargetOffset / pageWidth)
        let cellWidth = collectionView.bounds.width / 3
        
        targetContentOffset.pointee.x = page * cellWidth
    }
    
    // 居中缩放动画
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        collectionView.visibleCells.forEach { cell in
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            let cellCenter = collectionView.layoutAttributesForItem(at: indexPath)?.center ?? .zero
            let distance = abs(cellCenter.x - visiblePoint.x)
            
            let scale = max(1 - distance / collectionView.bounds.width, 0.8)
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // 处理无限滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let screenWidth = scrollView.bounds.width
        
        if currentOffsetX >= contentWidth - screenWidth * 2 {
            let jumpOffsetX = contentWidth/2 - screenWidth
            scrollView.contentOffset.x = jumpOffsetX
        } else if currentOffsetX <= screenWidth {
            let jumpOffsetX = contentWidth/2 - screenWidth
            scrollView.contentOffset.x = jumpOffsetX
        }
    }
}

// 自定义 Cell
class Cell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 12
        
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
