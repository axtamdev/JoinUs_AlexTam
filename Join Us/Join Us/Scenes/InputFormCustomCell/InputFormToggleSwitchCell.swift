//
//  InputFormToggleSwitchCell.swift
//  Join Us
//
//  Created by Alex Tam on 31/8/2023.
//

import Foundation
import UIKit
import SnapKit

protocol InputFormToggleSwitchCellDelegate: AnyObject {
    func toggleSwitchValueChanged(isOn: Bool)
}

class InputFormToggleSwitchCell: UITableViewCell{
    var delegate: InputFormToggleSwitchCellDelegate?
    
    var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        return toggleSwitch
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "toggleSwitchCell")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueChanged(_:)), for: .valueChanged)
        
        contentView.addSubview(container)
        container.addSubview(titleLbl)
        container.addSubview(toggleSwitch)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func toggleSwitchValueChanged(_ sender: UISwitch) {
        delegate?.toggleSwitchValueChanged(isOn: sender.isOn)
    }
}
