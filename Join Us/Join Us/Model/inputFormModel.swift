//
//  inputFormModel.swift
//  Join Us
//
//  Created by Alex Tam on 2/9/2023.
//

import Foundation

struct InputFormModel{
    var name: String?
    var phone: String?
    var gender: Gender?
    var isNeededUniform: Bool?
    var uniformSize: String?
}

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

enum UniformSize: String {
    case small = "S"
    case medium = "M"
    case large = "L"
    case extraLarge = "XL"
}
