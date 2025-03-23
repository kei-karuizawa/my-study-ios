//
//  ScrollableText.swift
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2025/3/22.
//

import UIKit

class ScrollableText: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()
    private let textField = UITextField()
    
    // 文本颜色
    var textColor: UIColor = .black {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    // 文本字体
    var font: UIFont = .systemFont(ofSize: 56) {
        didSet {
            textLabel.font = font
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 设置滚动视图
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        // 设置文本标签
        textLabel.textAlignment = .right
        textLabel.font = .systemFont(ofSize: 20)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textLabel)
        
        // 设置输入框
        textField.delegate = self
        //textField.isHidden = true // 隐藏输入框，通过代码控制输入
        //textField.text = "afadshfhaskjdhfkjashdkjfhakjsdhkfjahskjdhfkjahsdkjfhakjsdf"
        addSubview(textField)
        
        textLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.top.bottom.left.right.equalToSuperview()
            make.width.greaterThanOrEqualToSuperview()
        }
        
        textField.placeholder = "afasdfasdf"
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.height.equalTo(56)
        }
        
        // 初始化文本内容
        updateText("")
    }
    
    // MARK: - Text Handling
    func updateText(_ newText: String) {
        textLabel.text = newText
        textLabel.sizeToFit()
        
        // 更新文本标签的布局
        let labelWidth = textLabel.frame.width
        let contentWidth = max(labelWidth, scrollView.frame.width)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        
        // 将文本标签放置在滚动视图的最右边
        textLabel.frame.origin.x = max(0, contentWidth - scrollView.frame.width)
        
        // 滚动到最右边
        scrollView.setContentOffset(CGPoint(x: max(0, labelWidth - scrollView.frame.width), y: 0), animated: true)
    }
    
    // MARK: - Public Methods
    func appendText(_ text: String) {
        let currentText = textLabel.text ?? ""
        updateText(currentText + text)
    }
    
    func clearText() {
        updateText("")
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 获取当前文本
        let currentText = textLabel.text ?? ""
//        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let newText = textField.text
        
        // 更新文本
        updateText(newText ?? "")
        return true // 阻止输入框自身更新
    }
    
    // MARK: - Input Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textField.becomeFirstResponder() // 激活输入
    }
}
