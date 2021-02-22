//
//  OperationTask.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIOperation<T: APIResponseProtocol>: APIOperationProtocol {

    // MARK: - Typealias
    typealias Output = T
    typealias DataResponseSuccess = (_ result: Output) -> Void
    typealias DataResponseError = (_ error: APIError) -> Void
    typealias ErrorDialogResponse = (() -> Void)
    typealias OfflineDialogResponse = ((_ tapRetry: Bool) -> Void)
    
    // MARK: - Constants
    struct TaskData {
        var responseQueue: DispatchQueue = .main
        var showIndicator: Bool = true
        var autoShowApiErrorAlert = APIConfiguration.autoShowApiErrorAlert
        var autoPopPreviousVCWhenOffline = false
        var autoShowRequestErrorAlert = APIConfiguration.autoShowRequestErrorAlert
        var autoShowNoNetworkAlert = APIConfiguration.autoShowNoNetWorkAlert
        var didCloseApiErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseRequestErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseOfflineDialogHandler: OfflineDialogResponse? = nil
        var successHandler: DataResponseSuccess? = nil
        var failureHandler: DataResponseError? = nil
        init() { }
    }
    
    // MARK: - Variables
    private var taskData = TaskData()
    private var dispatcher: APIDispatcher?
    
    var request: APIRequest?
    
    // MARK: - Init & deinit
    init(request: APIRequest?) {
        self.request = request
        dispatcher = APIDispatcher()
    }
    
    // MARK: - Builder (public)
    @discardableResult
    func set(responseQueue: DispatchQueue) -> APIOperation<Output> {
        taskData.responseQueue = responseQueue
        return self
    }
    
    @discardableResult
    // Load request without: showing indicator + showing api error alert + request error alert automatically
    func set(silentLoad: Bool) -> APIOperation<Output> {
        taskData.showIndicator = !silentLoad
//        taskData.autoShowApiErrorAlert = !silentLoad
//        taskData.autoShowRequestErrorAlert = !silentLoad
        taskData.autoShowNoNetworkAlert = !silentLoad
        return self
    }
    
    @discardableResult
    func showIndicator(_ show: Bool) -> APIOperation<Output> {
        taskData.showIndicator = show
        return self
    }
    
    @discardableResult
    func autoPopPreviousVCWhenOffline(_ show: Bool) -> APIOperation<Output> {
        taskData.autoPopPreviousVCWhenOffline = show
        return self
    }
    
    @discardableResult
    func autoShowApiErrorAlert(_ show: Bool) -> APIOperation<Output> {
//        taskData.autoShowApiErrorAlert = show
        return self
    }
    
    @discardableResult
    func autoShowRequestErrorAlert(_ show: Bool) -> APIOperation<Output> {
//        taskData.autoShowRequestErrorAlert = show
        return self
    }
    
    @discardableResult
    func didCloseApiErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseApiErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseRequestErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseRequestErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseOfflineErrorDialog(_ handler: @escaping OfflineDialogResponse) -> APIOperation<Output> {
        taskData.didCloseOfflineDialogHandler = handler
        return self
    }
    
    // MARK: - Executing functions (public)
    @discardableResult
    func execute(target: UIViewController? = nil, success: DataResponseSuccess? = nil, failure: DataResponseError? = nil) -> APIOperation<Output> {
        func run(queue: DispatchQueue?, body: @escaping () -> Void) {
            (queue ?? .main).async {
                body()
            }
        }
        dispatcher?.target = target
        taskData.successHandler = success
        taskData.failureHandler = failure
        let showIndicator = taskData.showIndicator
        let responseQueue = taskData.responseQueue
        if let request = self.request {
            if showIndicator {
                run(queue: .main) { APIUIIndicator.showIndicator() }
            }
            // Print information of request
            request.printInformation()
            print("▶︎ [\(request.name)] is requesting...")
            
            // Execute request
            dispatcher?.execute(request: request, completed: { response in
                if showIndicator {
                    run(queue: .main) { APIUIIndicator.hideIndicator() }
                }
                switch response {
                case .success(let json):
                    print("▶︎ [\(request.name)] succeed !")
                    print(json)
                    run(queue: responseQueue) {
                        self.callbackSuccess(output: T(json: json))
                    }
                case .error(let error):
                    print("▶︎ [\(request.name)] error message: \"\(error.message ?? "empty")\"")
                    run(queue: responseQueue) {
                        self.callbackError(error: error)
                    }
                }
            })
        } else {
            run(queue: responseQueue) {
                self.callbackError(error: APIError.unknown)
            }
        }
        return self
    }
    
    func cancel() {
        dispatcher?.cancel()
    }
    
    // MARK: - Handle callback with input data
    private func callbackSuccess(output: T) {
        taskData.successHandler?(output)
    }
    
    private func callbackError(error: APIError) {
        if error.statusCode != 502 {
            DispatchQueue.main.async {
                self.showErrorAlertIfNeeded(error: error)
            }
        }
        taskData.failureHandler?(error)
    }
    
    // MARK: - Alerts
    private func showErrorAlertIfNeeded(error: APIError) {
        switch error {
        case .api:
            guard taskData.autoShowApiErrorAlert else { return }
            let alert = APIUIEvent.apiErrorDialog(error: error, completion: {
                APIAlertPresenter.instance.removeCurrentAlert()
                self.taskData.didCloseApiErrorDialogHandler?()
            })
            guard !APIAlertPresenter.instance.isPresentingAlert else {
                APIAlertPresenter.instance.removeCurrentAlert()
    
                APIAlertPresenter.instance.add(alert: alert)
                return
            }
            APIAlertPresenter.instance.isPresentingAlert = true
          
            VCService.present(controller: alert)

        case .request(_, let requestError, let errorMessage, _):
            if let requestError = requestError, taskData.autoShowNoNetworkAlert, requestError.isInternetOffline || requestError.isNetworkConnectionLost {
                return
            }
            guard taskData.autoShowRequestErrorAlert, let requestError = requestError else { return }
            var alert: UIAlertController!
            if requestError.isInternetOffline {
                alert = APIUIEvent.offlineErrorDialog(autoPopPreviousVC: self.taskData.autoPopPreviousVCWhenOffline,completion: { index, tapRetry in
                    APIAlertPresenter.instance.removeCurrentAlert()
                    if tapRetry {
                        self.execute(target: self.dispatcher?.target,
                                     success: self.taskData.successHandler,
                                     failure: self.taskData.failureHandler)
                    }
                })
            } else {
                if error.statusCode == APIError.APIErrorHttpCode.invalidToken, errorMessage != APIError.APIErrorHttpMessage.notPermit {
                    alert = APIUIEvent.requestErrorDialog(error: error, completion: {
                        APIAlertPresenter.instance.removeCurrentAlert()
                    })
                } else {
                    alert = APIUIEvent.requestErrorDialog(error: error, completion: {
                        APIAlertPresenter.instance.removeCurrentAlert()
                        self.taskData.didCloseRequestErrorDialogHandler?()
                    })
                }
            }
            
            APIAlertPresenter.instance.isPresentingAlert = true
            VCService.present(controller: alert)
        }
    }
    
    func refreshToken(completion: @escaping((_ success: Bool) -> Void)) {
        RefreshTokenAPI().execute(target: nil, success: { (response) in
            completion(response.isSuccess)
        }) { (error) in
            completion(false)
        }
    }
}
