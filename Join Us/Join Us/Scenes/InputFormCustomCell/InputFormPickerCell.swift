//
//  InputFormPickerCell.swift
//  Join Us
//
//  Created by Alex Tam on 31/8/2023.
//

import Foundation
import UIKit
import SnapKit

protocol InputFormPickerCellDelegate: AnyObject{
    func didSelectSize(_ size: String)
}

class InputFormPickerCell: UITableViewCell, UITextFieldDelegate{
    var delegate: InputFormPickerCellDelegate?
    var pickerOption: [String]?
    
    var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    var sizeTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 18)
        tf.text = "Not set"
        tf.textColor = .systemGray
        tf.textAlignment = .right
        tf.tintColor = .clear
        return tf
    }()
    
    let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let pickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "pickerCell")
        setupLayout()
        setupPicker()
        
        pickerView.delegate = self
        sizeTextField.inputView = pickerView
        sizeTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        contentView.addSubview(container)
        container.addSubview(titleLbl)
        container.addSubview(sizeTextField)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        sizeTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    func setupPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([doneButton], animated: false)
        sizeTextField.inputAccessoryView = toolbar
        
        contentView.addSubview(pickerContainer)
        pickerContainer.isHidden = true
        pickerContainer.addSubview(picker)
        
        picker.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalToSuperview()
        }
        
        pickerContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(sizeTextField.snp.bottom)
        }
    }
    
    @objc private func handleCellTap(){
        showSizePicker()
    }
    
    @objc private func doneButtonTapped() {
        hidePicker()
    }
    
    private func showSizePicker(){
        pickerContainer.isHidden = false
    }
}

extension InputFormPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerOption = pickerOption else {return 0}
        
        return pickerOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerOption = pickerOption else {return nil}
        
        return pickerOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerOption = pickerOption else {return}
        
        sizeTextField.text = pickerOption[row]
        sizeTextField.textColor = .black
        sizeTextField.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func hidePicker() {
        guard let selectedSize = sizeTextField.text else {return}
        sizeTextField.resignFirstResponder()
        pickerContainer.isHidden = true
        
        if selectedSize != "Not set"{
            delegate?.didSelectSize(selectedSize)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
