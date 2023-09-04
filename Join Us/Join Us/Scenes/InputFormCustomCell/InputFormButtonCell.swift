//
//  InputFormButtonCell.swift
//  Join Us
//
//  Created by Alex Tam on 2/9/2023.
//

import Foundation
import UIKit
import SnapKit

class InputFormButtonCell: UITableViewCell{
    var submitBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        contentView.addSubview(container)
        container.addSubview(submitBtn)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        submitBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
            
        }
    }
    
    func shouldEnableSubmitButton(_ enable: Bool){
        submitBtn.isEnabled = enable
        submitBtn.backgroundColor = submitBtn.isEnabled ? .systemGreen : .systemGray
    }
}
