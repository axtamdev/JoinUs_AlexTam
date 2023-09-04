//
//  InputFormTextInputCell.swift
//  Join Us
//
//  Created by Alex Tam on 31/8/2023.
//

import Foundation
import UIKit
import SnapKit

protocol InputFormTextInputCellDelegate: AnyObject{
    func didEndEditingTextField(_ phoneNumber: String, in cell: InputFormTextInputCell)
}

class InputFormTextInputCell: UITableViewCell{
    var delegate: InputFormTextInputCellDelegate?
    var textFieldType: RowType?
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let errorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var inputTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    var errorIconLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.isHidden = false
        lbl.text = "⚠"
        return lbl
    }()
    
    var errorTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.isHidden = false
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        setupLayout()
        inputTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let content = UIView()
        
        inputContainer.addSubview(titleLbl)
        inputContainer.addSubview(inputTextField)
        errorContainer.addSubview(errorIconLabel)
        errorContainer.addSubview(errorTextLabel)
        content.addSubview(inputContainer)
        content.addSubview(errorContainer)
        container.addSubview(content)
        
        content.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        inputContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            
            if errorContainer.isHidden{
                make.bottom.equalToSuperview()
            }
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLbl.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        errorContainer.snp.makeConstraints { make in
            make.top.equalTo(inputContainer.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        errorIconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        errorTextLabel.snp.makeConstraints { make in
            make.left.equalTo(errorIconLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(errorContainer.snp.top)
            make.bottom.equalTo(errorContainer.snp.bottom)
        }
    }
    
    func setupErrorMsg(message: String){
        errorTextLabel.text = message
        errorContainer.isHidden = false
        
        inputContainer.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        errorContainer.snp.remakeConstraints { make in
            make.top.equalTo(inputContainer.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    func removeErrorMsg(){
        errorContainer.isHidden = true
        
        inputContainer.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        errorContainer.snp.removeConstraints()
    }
}

extension InputFormTextInputCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldType = textFieldType{
            if textFieldType == .name {
                guard let text = textField.text else {
                    return
                }
                
                delegate?.didEndEditingTextField(text, in: self)
                
            } else if textFieldType == .phone {
                guard let phoneNumber = textField.text else {
                    return
                }
                
                delegate?.didEndEditingTextField(phoneNumber, in: self)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
}
