//
//  SelectableButton.swift
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2025/3/22.
//

import UIKit

class SelectableButton: UIView, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    private let button = UIButton(type: .system)
    private let tableView = UITableView()
    private var isTableViewVisible = false
    private var items: [String] = []
    private var buttonTitle: String = "Show List"
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Public Methods
    func configure(buttonTitle: String, items: [String]) {
        self.buttonTitle = buttonTitle
        self.items = items
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        tableView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        // 设置表格视图
        tableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        tableView.backgroundColor = .systemBlue
        tableView.layer.cornerRadius = 20
        addSubview(tableView)
        
        
        // 设置按钮
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
        addSubview(button)
        
        
    }
    
    // MARK: - Button Action
    @objc private func buttonTapped() {
        isTableViewVisible.toggle()
        
        if isTableViewVisible {
            // 显示表格视图
            tableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 200)
            }
        } else {
            // 隐藏表格视图
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0)
            }) { _ in
                self.tableView.isHidden = true
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(items[indexPath.row])")
        button.setTitle(items[indexPath.row], for: .normal)
        buttonTapped()
    }
}
