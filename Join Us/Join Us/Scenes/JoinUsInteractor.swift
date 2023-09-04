//
//  JoinUsInteractor.swift
//  Join Us
//
//  Created by Alex Tam on 2/9/2023.
//

import Foundation
import UIKit

enum InputFormError: Error {
    case invalidNameLengthTooShort
    case invalidNameLengthTooLong
    case invalidNameCharacters
    case invalidPhoneNumber
}

protocol JoinUsInteractorProtocol: InputFormTextInputCellDelegate {
    func didEndEditingTextField(_ phoneNumber: String, in cell: InputFormTextInputCell)
    func validatePhoneNumber(_ phoneNumber: String)  -> Result<Void, InputFormError>
    func validateName(_ name: String) -> Result<Void, InputFormError>
}

class JoinUsInteractor: JoinUsInteractorProtocol{
    var presenter: JoinUsPresenter?
    var profile: InputFormModel = InputFormModel()
    
    var rowData: [[RowType]] = [[.name, .phone, .gender], [.uniform, .uniformSize], [.submitBtn]]
    var isNameInputError: Bool = false
    var isPhoneInputError: Bool = false
    var isUniformSizeIsHidden: Bool = true
    var isSubmitBtnEnabled: Bool = false
    
    func validateFormData(inputForm: UITableView){
        guard let presenter = presenter else {return}
        var hasValidationError = false
        
        if profile.name == nil || profile.phone == nil || profile.gender == nil {
            hasValidationError = true
        } else if profile.isNeededUniform == true && profile.uniformSize == nil{
            hasValidationError = true
        }
        
        isSubmitBtnEnabled = !hasValidationError
        presenter.updateInputForm()
    }
    
    func didEndEditingTextField(_ data: String, in cell: InputFormTextInputCell) {
        guard let presenter = presenter else {return}
        switch cell.textFieldType{
        case .name:
            let result = validateName(data)
            
            switch result{
            case .success:
                presenter.hideErrorMessage(in: cell)
            case .failure(let error):
                presenter.showErrorMessage(in: cell, error: error)
            }
            
        case .phone:
            let result = validatePhoneNumber(data)
            
            switch result{
            case .success:
                presenter.hideErrorMessage(in: cell)
            case .failure(let error):
                presenter.showErrorMessage(in: cell, error: error)
            }
            
        default:
            return
        }
    }
    
    func validateName(_ name: String) -> Result<Void, InputFormError> {
        let nameRegex = "^[a-zA-Z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        if name.count == 0 {
            profile.name = nil
        } else if !namePredicate.evaluate(with: name) {
            isNameInputError = true
            profile.name = nil
            return .failure(.invalidNameCharacters)
        } else if name.count < 5 {
            isNameInputError = true
            profile.name = nil
            return .failure(.invalidNameLengthTooShort)
            
        } else if name.count > 35 {
            isNameInputError = true
            profile.name = nil
            return .failure(.invalidNameLengthTooLong)
        }
        
        isNameInputError = false
        profile.name = name
        return .success(())
    }
    
    func validatePhoneNumber(_ phoneNumber: String)  -> Result<Void, InputFormError> {
        let phoneRegex = "^\\+\\d+$"
        
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if phoneNumber.count == 0 {
            profile.phone = nil
        } else if phonePredicate.evaluate(with: phoneNumber) {
            isPhoneInputError = false
            profile.phone = phoneNumber
            return .success(())
        } else {
            isPhoneInputError = true
            profile.phone = nil
            return .failure(.invalidPhoneNumber)
        }
        return .success(())
    }
    
    func updateGender(with segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            profile.gender = Gender.male
        case 1:
            profile.gender = Gender.female
        case 2:
            profile.gender = Gender.other
        default:
            break
        }
    }
    
    func toggleSwitchValueChanged(isOn: Bool) {
        guard let presenter = presenter else {return}
        isUniformSizeIsHidden = !isOn
        profile.isNeededUniform = isOn
        presenter.updateInputForm()
    }
    
    func updateSize(_ size: String){
        if size != "Not set"{
            profile.uniformSize = size
        }
    }
}
