//
//  TopView.swift
//  ImagesSearch
//
//  Created by Olya Sabadina on 2023-07-20.
//

import UIKit

class TopView: UIView {

    private var stackView = UIStackView()
    let backButton = UIButton(type: .system)
    let sortedButton = UIButton(type: .system)
    let textField = UITextField()

    override init(frame: CGRect) {
        super .init(frame: frame)
        setView()
        setTextField()
        setLeftButtonOnTextField()
        setBackButton()
        setSortedButton()
        configStackView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        backgroundColor = .white
        layer.shadowOffset = .init(width: 0, height: 0.5)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 0.8
    }
    
    private func configStackView() {
        stackView = UIStackView(arrangedSubviews: [backButton, textField, sortedButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        addSubview(stackView)
    }
    
    private func setTextField() {
        textField.placeholder = " Search images, vectors "
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.setBorderLayer(backgroundColor: .secondarySystemBackground.withAlphaComponent(0.6), borderColor: .lightGray.withAlphaComponent(0.4), borderWidth: 1, cornerRadius: 4, tintColor: nil)
    }

    private func setLeftButtonOnTextField() {
        let leftButton = UIButton()
        leftButton.setImage(IconsEnum.magnifyingglass, for: .normal)
        leftButton.tintColor = .secondaryLabel
        leftButton.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        leftView.addSubview(leftButton)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = leftView
    }
    
    private func setBackButton() {
        backButton.setImage(UIImage(named: "P"), for: .normal)
        backButton.setBorderLayer(backgroundColor: .blue, borderColor: .lightText, borderWidth: 1, cornerRadius: 4, tintColor: .white)
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
    }
    
    private func  setSortedButton() {
        sortedButton.setImage(IconsEnum.sortedImage, for: .normal)
        sortedButton.setBorderLayer(backgroundColor: .clear, borderColor: .lightGray.withAlphaComponent(0.4), borderWidth: 1, cornerRadius: 4, tintColor: .black)
        sortedButton.heightAnchor.constraint(equalTo: sortedButton.widthAnchor).isActive = true
        sortedButton.showsMenuAsPrimaryAction = true
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
}
