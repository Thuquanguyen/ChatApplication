//
//  FieldsValidationUtils.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 7/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

class FieldsValidationUtils {
    
    typealias ErrorCloseDialogCompletion = ((_ result: FieldsValidationResult) -> Void)
    
    enum FieldValidationType {
        case search
        case title
        case content
        case email
        case phone
        case file
        case custom(title: String)
        
        func fieldName() -> String {
            switch self {
            case .search:
                return "L10n.FieldsValidation.FieldType.search"
            case .title:
                return "L10n.FieldsValidation.FieldType.title"
            case .content:
                return "L10n.FieldsValidation.FieldType.content"
            case .email:
                return "L10n.FieldsValidation.FieldType.email"
            case .phone:
                return "L10n.FieldsValidation.FieldType.phone"
            case .file:
                return "L10n.FieldsValidation.FieldType.file"
            case .custom(let title):
                return title
            }
        }
    }
    
    private struct FieldConfig {
        var fieldValidationType: FieldValidationType = .title
        var autoShowErrorAlert = true
        var didCloseErrorDialogHandler: ErrorCloseDialogCompletion? = nil
        init() {}
    }
    
    private var fieldConfig = FieldConfig()
    static let instance = FieldsValidationUtils()
    
    
    func validateField(text: String?, fieldValidationType: FieldValidationType?) -> FieldsValidationResult {
        fieldConfig.fieldValidationType = fieldValidationType ?? .title
        
        let errorDetected = FieldsValidationError.getError(fieldsValidationType: fieldConfig.fieldValidationType, text: text)
        self.showErrorAlertIfNeeded(fieldsValidationResult: errorDetected)
        
        return errorDetected
    }
    
    func validateFieldWithoutAlert(text: String?, fieldValidationType: FieldValidationType?) -> Bool {
        fieldConfig.fieldValidationType = fieldValidationType ?? .title
        let errorDetected = FieldsValidationError.getError(fieldsValidationType: fieldConfig.fieldValidationType, text: text)
        return errorDetected.isValid
    }
    
    // MARK: - Alerts
    private func showErrorAlertIfNeeded(fieldsValidationResult: FieldsValidationResult) {
        if fieldsValidationResult.isValid == false {
            if let error = fieldsValidationResult.error {
                guard fieldConfig.autoShowErrorAlert else { return }
                let alert = FieldsValidationAlertController.showErrorDialog(error: error, completion: {
                    FieldsValidationAlertPresenter.instance.removeCurrentAlert()
                    self.fieldConfig.didCloseErrorDialogHandler?(fieldsValidationResult)
                })
                guard !FieldsValidationAlertPresenter.instance.isPresentingAlert else {
                    FieldsValidationAlertPresenter.instance.removeCurrentAlert()
                    
                    FieldsValidationAlertPresenter.instance.add(alert: alert)
                    return
                }
                APIAlertPresenter.instance.isPresentingAlert = true
                
                VCService.present(controller: alert)
            }
        }
    }
}


extension FieldsValidationUtils {
    @discardableResult
    func autoShowErrorAlert(_ show: Bool) -> FieldsValidationUtils {
        fieldConfig.autoShowErrorAlert = show
        return self
    }
    
    @discardableResult
    func didCloseErrorDialog(_ handler: @escaping ErrorCloseDialogCompletion) -> FieldsValidationUtils {
        fieldConfig.didCloseErrorDialogHandler = handler
        return self
    }
}


