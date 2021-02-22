//
//  FieldsValidationError.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 7/4/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

struct FieldsValidationResult {
    var fieldsValidationType: FieldsValidationUtils.FieldValidationType = .title
    var isValid: Bool = true
    var error: String? = nil
    var fileType: Constants.FileType = .none
}

class FieldsValidationError {
    
    static func getError(fieldsValidationType: FieldsValidationUtils.FieldValidationType, text: String?) -> FieldsValidationResult {
        
        var fieldsValidationResult = FieldsValidationResult()
        fieldsValidationResult.fieldsValidationType = fieldsValidationType
        
        var result: (isValid: Bool, error: String?)
        
        switch fieldsValidationType {
        case .title:
            result = validateTitleField(text: text)
        case .content:
            result = validateContentField(text: text)
        case .phone:
            result = validatePhoneField(text: text)
        case .email:
            result = validateEmailField(text: text)
        case .file:
            let url = URL(string: text ?? "")
            let fileType = validateFileType(url: url)
            fieldsValidationResult.fileType = fileType.fileType
            result = fileType.isValid ? validateFileSize(url: url) : (false, fileType.error)
        case .custom(let title):
            result = validateCustomType(title: title, text: text)
        default:
            result = (true, nil)
        }
      
        fieldsValidationResult.isValid = result.isValid
        fieldsValidationResult.error = result.error
        
        return fieldsValidationResult
    }
}


//MARK: VALIDATE FIELDS
extension FieldsValidationError {
    private static func validateTitleField(text: String?) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        let commonValidateResult = validateCommon(text: text, limitedCount: Constants.limitCharacterSearch, type: .title)
        if commonValidateResult.isValid == false {
            return commonValidateResult
        } else {
            //Other cases
            isValid = true
            error = nil
        }
        
        return (isValid, error)
    }
    
    private static func validateContentField(text: String?) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        let commonValidateResult = validateCommon(text: text, limitedCount: Constants.limitCharacterContent, type: .content)
        if commonValidateResult.isValid == false {
            return commonValidateResult
        } else {
            //Other cases
            isValid = true
            error = nil
        }
        
        return (isValid, error)
    }
    
    private static func validatePhoneField(text: String?) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        let commonValidateResult = validateCommon(text: text, limitedCount: Constants.limitCharacterPhone, type: .content)
        if commonValidateResult.isValid == false {
            return commonValidateResult
        } else {
            if text?.isValidPhone != true {
                isValid = false
                error = ""
            }
        }
        return (isValid, error)
    }
    
    private static func validateEmailField(text: String?) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        let commonValidateResult = validateCommon(text: text, limitedCount: Constants.limitCharacterEmail, type: .content)
        if commonValidateResult.isValid == false {
            return commonValidateResult
        } else {
            if text?.isValidEmail != true {
                isValid = false
                error = ""
            }
        }
        
        return (isValid, error)
    }
    
    private static func validateFileType(url: URL?) -> (isValid: Bool,fileType: Constants.FileType, error: String?) {
        var isValid = true
        var error: String?
        
        let fileType = Constants.FileType.checkFileDocument(url)
        
        if fileType == .none {
            isValid = false
            error = "personal_validate_upload_file".localized
        }
        
        return (isValid, fileType, error)
    }
    
    private static func validateFileSize(url: URL?) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        let fileSize = Utils.checkFileSize(url)
        
        if !fileSize {
            isValid = false
            error = ""
        }
        return (isValid, error)
    }
    
    private static func validateCustomType(title: String, text: String?) -> (isValid: Bool, error: String?) {
        let isValid = validateCommon(text: text, limitedCount: Constants.limitCharacterContent, type: .content).isValid
        let error: String? = isValid ? nil : "Vui lòng nhập \(title.lowercased()) hợp lệ!"
        
        return (isValid, error)
    }
}


//MARK: VALIDATE UTILITIES
extension FieldsValidationError {
    private static func validateCommon(text: String?, limitedCount: Int, type:  FieldsValidationUtils.FieldValidationType) -> (isValid: Bool, error: String?) {
        var isValid = true
        var error: String?
        
        if text?.trimWhiteSpacesAndNewLines.isEmpty ?? true {
            isValid = false
            error = ""
        } else if text?.trimWhiteSpacesAndNewLines.count ?? 0 > limitedCount {
            isValid = false
            error = ""
        }
        
        return (isValid, error)
    }
}
