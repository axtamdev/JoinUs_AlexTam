//
//  JoinUsPresenter.swift
//  Join Us
//
//  Created by Alex Tam on 2/9/2023.
//

import Foundation

protocol JoinUsPresenterProtocol{
    func showErrorMessage(in cell: InputFormTextInputCell, error: InputFormError)
    func hideErrorMessage(in cell: InputFormTextInputCell)
}

class JoinUsPresenter: JoinUsPresenterProtocol{
    weak var view: JoinUsViewController?
    
    func updateInputForm(){
        guard let view = view else {return}
        view.inputForm.reloadData()
    }
    
    func showErrorMessage(in cell: InputFormTextInputCell, error: InputFormError) {
        guard let view = view else {return}
        
        switch error{
        case .invalidNameCharacters:
            cell.setupErrorMsg(message: "Only alphabetic characters are accepted")
            
        case .invalidNameLengthTooShort:
            cell.setupErrorMsg(message: "Name shall be more than 5 characters")
            
        case .invalidNameLengthTooLong:
            cell.setupErrorMsg(message: "Name shall be less than 35 characters")
            
        case .invalidPhoneNumber:
            cell.setupErrorMsg(message: "Please input correct phone number")
        }
        
        view.inputForm.reloadData()
    }
    
    func hideErrorMessage(in cell: InputFormTextInputCell) {
        guard let view = view else {return}
        cell.removeErrorMsg()
        
        view.inputForm.reloadData()
    }
}
