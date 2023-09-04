//
//  InputFormSegmentControlCell.swift
//  Join Us
//
//  Created by Alex Tam on 31/8/2023.
//

import Foundation
import UIKit
import SnapKit

class InputFormSegmentControlCell: UITableViewCell{
    var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "???"
        return lbl
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "segmentControlCell")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout(){
        contentView.addSubview(container)
        container.addSubview(titleLbl)
        container.addSubview(segmentedControl)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalTo(titleLbl.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}


