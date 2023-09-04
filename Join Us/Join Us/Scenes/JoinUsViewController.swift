//
//  JoinUsViewController.swift
//  Join Us
//
//  Created by Alex Tam on 31/8/2023.
//

import UIKit
import SnapKit

enum RowType{
    case name
    case phone
    case gender
    case uniform
    case uniformSize
    case submitBtn
}

class JoinUsViewController: UIViewController{
    var interactor: JoinUsInteractor?
    
    var normalCellHeight: CGFloat = 70
    var errorCellHeight: CGFloat = 100
    
    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Join us"
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        return lbl
    }()
    
    var inputForm = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        setupLayout()
        setupInputForm()
    }
    
    func setupInputForm(){
        inputForm.delegate = self
        inputForm.dataSource = self
        inputForm.isScrollEnabled = false
        inputForm.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        
        inputForm.register(InputFormTextInputCell.self, forCellReuseIdentifier: "nameInputCell")
        inputForm.register(InputFormTextInputCell.self, forCellReuseIdentifier: "phoneNumberInputCell")
        inputForm.register(InputFormSegmentControlCell.self, forCellReuseIdentifier: "genderSelectionCell")
        inputForm.register(InputFormToggleSwitchCell.self, forCellReuseIdentifier: "uniformToggleCell")
        inputForm.register(InputFormPickerCell.self, forCellReuseIdentifier: "sizeSelectionCell")
        inputForm.register(InputFormButtonCell.self, forCellReuseIdentifier: "submitButtonCell")
    }
    
    func setupLayout(){
        view.addSubview(container)
        container.addSubview(titleLbl)
        container.addSubview(inputForm)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIWindow.keySafeAreaTop + 20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        inputForm.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension JoinUsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let interactor = interactor else {return 0}
        return interactor.rowData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let interactor = interactor else {return 0}
        return interactor.rowData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let interactor = interactor else {return UITableViewCell()}
        
        let rowType = interactor.rowData[indexPath.section][indexPath.row]
        
        switch rowType{
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameInputCell", for: indexPath) as! InputFormTextInputCell
            
            cell.textFieldType = .name
            cell.delegate = self
            cell.titleLbl.text = "Name"
            cell.inputTextField.placeholder = "your name"
            cell.selectionStyle = .none
            
            return cell
            
        case .phone:
            let cell = tableView.dequeueReusableCell(withIdentifier: "phoneNumberInputCell", for: indexPath) as! InputFormTextInputCell
            
            cell.textFieldType = .phone
            cell.delegate = self
            cell.titleLbl.text = "Phone"
            cell.inputTextField.placeholder = "your phone number"
            cell.inputTextField.keyboardType = .phonePad
            cell.selectionStyle = .none

            return cell
            
        case .gender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "genderSelectionCell", for: indexPath) as! InputFormSegmentControlCell
            
            cell.titleLbl.text = "Gender"
            if cell.segmentedControl.numberOfSegments == 0 {
                cell.segmentedControl.insertSegment(withTitle: Gender.male.rawValue, at: 0, animated: false)
                cell.segmentedControl.insertSegment(withTitle: Gender.female.rawValue, at: 1, animated: false)
                cell.segmentedControl.insertSegment(withTitle: Gender.other.rawValue, at: 2, animated: false)
            }
            
            cell.segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
            
            cell.selectionStyle = .none
            
            return cell
            
        case .uniform:
            let cell = tableView.dequeueReusableCell(withIdentifier: "uniformToggleCell", for: indexPath) as! InputFormToggleSwitchCell
            
            cell.titleLbl.text = "Need Uniform"
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
            
        case .uniformSize:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sizeSelectionCell", for: indexPath) as! InputFormPickerCell
            let uniformSize: [UniformSize] = [.small, .medium, .large, .extraLarge]
            
            cell.titleLbl.text = "Uniform Size"
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.delegate = self
            cell.pickerOption = uniformSize.map { $0.rawValue }
            
            return cell
            
        case .submitBtn:
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitButtonCell", for: indexPath) as! InputFormButtonCell
            
            cell.selectionStyle = .none
            cell.submitBtn.setTitle("Submit", for: .normal)
            cell.shouldEnableSubmitButton(interactor.isSubmitBtnEnabled)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let interactor = interactor else { return 0 }
        let rowType = interactor.rowData[indexPath.section][indexPath.row]
        
        switch rowType {
        case .name:
            return interactor.isNameInputError ? errorCellHeight : normalCellHeight
            
        case .phone:
            return interactor.isPhoneInputError ? errorCellHeight : normalCellHeight
            
        case .gender, .uniform, .submitBtn:
            return normalCellHeight
            
        case .uniformSize:
            return interactor.isUniformSizeIsHidden ? 0 : normalCellHeight
        }
    }
}

extension JoinUsViewController: InputFormTextInputCellDelegate{
    func didEndEditingTextField(_ phoneNumber: String, in cell: InputFormTextInputCell) {
        guard let interactor = interactor else { return }
        interactor.didEndEditingTextField(phoneNumber, in: cell)
        
        interactor.validateFormData(inputForm: inputForm)
    }
}

extension JoinUsViewController: InputFormToggleSwitchCellDelegate{
    func toggleSwitchValueChanged(isOn: Bool) {
        guard let interactor = interactor else { return }
        interactor.toggleSwitchValueChanged(isOn: isOn)
        interactor.validateFormData(inputForm: inputForm)
    }
}

extension JoinUsViewController{
    @objc func segmentValueChanged(_ sender: UISegmentedControl){
        guard let interactor = interactor else {return}
        interactor.updateGender(with: sender.selectedSegmentIndex)
        
        interactor.validateFormData(inputForm: inputForm)
    }
}

extension JoinUsViewController: InputFormPickerCellDelegate{
    func didSelectSize(_ size: String) {
        guard let interactor = interactor else {return}
        interactor.updateSize(size)
        
        interactor.validateFormData(inputForm: inputForm)
    }
}
