import UIKit

class ViewController: UIViewController {
    
    let topView = UIView()
    let middleView = UIView()
    let bottomView = UIView()
    
    var topCollectionView: UICollectionView!
    var middleCollectionView: UICollectionView!
    var bottomCollectionView: UICollectionView!
    
    // 保存约束引用，以便后续修改
    var topBottomConstraint: NSLayoutConstraint?
    var middleBottomConstraint: NSLayoutConstraint?
    var topHeightConstraint: NSLayoutConstraint?
    var middleHeightConstraint: NSLayoutConstraint?
    var bottomHeightConstraint: NSLayoutConstraint?
    
    // 初始状态每行8个按钮，动画后每行4个按钮
    let initialItemsPerRow: CGFloat = 8
    let afterAnimationItemsPerRow: CGFloat = 4
    
    // 按钮之间的间距
    let itemSpacing: CGFloat = 8
    let lineSpacing: CGFloat = 8
    let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置视图背景颜色
        topView.backgroundColor = .red
        middleView.backgroundColor = .green
        bottomView.backgroundColor = .blue
        
        // 添加视图到主视图
        view.addSubview(topView)
        view.addSubview(middleView)
        view.addSubview(bottomView)
        
        // 设置 UICollectionView
        setupCollectionViews()
        
        // 设置 Auto Layout 约束
        setupConstraints()
        
        // 5秒后移除中间的视图并添加动画
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateMiddleViewRemoval()
        }
    }
    
    func setupCollectionViews() {
        // 创建顶部CollectionView
        let topLayout = createCollectionViewLayout(itemsPerRow: initialItemsPerRow)
        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: topLayout)
        configureCollectionView(topCollectionView)
        topView.addSubview(topCollectionView)
        
        // 创建中间CollectionView
        let middleLayout = createCollectionViewLayout(itemsPerRow: initialItemsPerRow)
        middleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: middleLayout)
        configureCollectionView(middleCollectionView)
        middleView.addSubview(middleCollectionView)
        
        // 创建底部CollectionView
        let bottomLayout = createCollectionViewLayout(itemsPerRow: initialItemsPerRow)
        bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: bottomLayout)
        configureCollectionView(bottomCollectionView)
        bottomView.addSubview(bottomCollectionView)
        
        // 设置CollectionView约束
        setupCollectionViewConstraints()
    }
    
    func createCollectionViewLayout(itemsPerRow: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        // 计算每个按钮的尺寸，使每行显示指定数量的按钮
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = sectionInset.left + sectionInset.right + (itemsPerRow - 1) * itemSpacing
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        let itemSize = CGSize(width: itemWidth, height: itemWidth) // 正方形按钮
        
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = sectionInset
        
        return layout
    }
    
    func configureCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "ButtonCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            topCollectionView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            topCollectionView.topAnchor.constraint(equalTo: topView.topAnchor),
            topCollectionView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            middleCollectionView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            middleCollectionView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            middleCollectionView.topAnchor.constraint(equalTo: middleView.topAnchor),
            middleCollectionView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor),
            
            bottomCollectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            bottomCollectionView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
    }
    
    func setupConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        middleView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        // 确保视图安全区域内布局
        let safeArea = view.safeAreaLayoutGuide
        
        // 基本约束
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        // 保存需要后续修改的约束引用
        topBottomConstraint = topView.bottomAnchor.constraint(equalTo: middleView.topAnchor)
        middleBottomConstraint = middleView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        
        // 计算屏幕高度的三分之一（考虑安全区域）
        let screenHeight = UIScreen.main.bounds.height
        let oneThirdHeight = screenHeight / 3
        
        // 设置三个视图高度相等
        topHeightConstraint = topView.heightAnchor.constraint(equalToConstant: oneThirdHeight)
        middleHeightConstraint = middleView.heightAnchor.constraint(equalToConstant: oneThirdHeight)
        bottomHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: oneThirdHeight)
        
        // 激活约束
        NSLayoutConstraint.activate([
            topBottomConstraint!,
            middleBottomConstraint!,
            topHeightConstraint!,
            middleHeightConstraint!,
            bottomHeightConstraint!
        ])
    }
    
    func animateMiddleViewRemoval() {
        // 首先确保所有CollectionView都滚动到顶部
        topCollectionView.setContentOffset(.zero, animated: false)
        middleCollectionView.setContentOffset(.zero, animated: false)
        bottomCollectionView.setContentOffset(.zero, animated: false)
        
        // 停用旧约束
        NSLayoutConstraint.deactivate([
            topBottomConstraint!,
            middleBottomConstraint!,
            topHeightConstraint!,
            middleHeightConstraint!,
            bottomHeightConstraint!
        ])
        
        // 计算屏幕高度的一半（考虑安全区域）
        let screenHeight = UIScreen.main.bounds.height
        let halfHeight = screenHeight / 2
        
        // 创建新约束
        let newTopBottomConstraint = topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        let newTopHeightConstraint = topView.heightAnchor.constraint(equalToConstant: halfHeight)
        let newBottomHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: halfHeight)
        
        // 激活新约束
        NSLayoutConstraint.activate([
            newTopBottomConstraint,
            newTopHeightConstraint,
            newBottomHeightConstraint
        ])
        
        // 创建新的布局，每行4个按钮
        let newTopLayout = createCollectionViewLayout(itemsPerRow: afterAnimationItemsPerRow)
        let newBottomLayout = createCollectionViewLayout(itemsPerRow: afterAnimationItemsPerRow)
        
        // 执行简单的动画
        UIView.animate(withDuration: 10.0, delay: 0, options: .curveEaseInOut, animations: {
            // 淡出中间视图
            self.middleView.alpha = 0
            
            // 应用新的视图布局
            self.view.layoutIfNeeded()
            
            // 同时应用新的CollectionView布局
            self.topCollectionView.setCollectionViewLayout(newTopLayout, animated: false)
            self.bottomCollectionView.setCollectionViewLayout(newBottomLayout, animated: false)
            
            // 强制立即更新布局
            self.topCollectionView.layoutIfNeeded()
            self.bottomCollectionView.layoutIfNeeded()
            
            // 确保在动画过程中CollectionView保持在顶部
            self.topCollectionView.contentOffset = .zero
            self.bottomCollectionView.contentOffset = .zero
            
        }) { _ in
            // 动画完成后移除中间视图
            self.middleView.removeFromSuperview()
            
            // 最后再次确保CollectionView在顶部
            self.topCollectionView.setContentOffset(.zero, animated: false)
            self.bottomCollectionView.setContentOffset(.zero, animated: false)
            
            print("动画完成！CollectionView始终保持在顶部位置")
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32 // 增加按钮数量以便铺满视图
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        
        // 根据不同的CollectionView设置不同的颜色
        if collectionView == topCollectionView {
            cell.backgroundColor = .systemYellow
        } else if collectionView == middleCollectionView {
            cell.backgroundColor = .systemOrange
        } else {
            cell.backgroundColor = .systemPurple
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选中了按钮: \(indexPath.item)")
    }
}

// MARK: - 自定义 UICollectionViewCell
class ButtonCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        // 设置内容
        setupContentViews()
        
        // 添加阴影效果
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        
        // 添加动画效果
        self.addTapAnimation()
    }
    
    private func setupContentViews() {
        // 添加图标
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.image = UIImage(systemName: "star.fill")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        // 添加标题
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.text = "按钮"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
    }
    
    private func addTapAnimation() {
        // 点击时的动画效果
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
