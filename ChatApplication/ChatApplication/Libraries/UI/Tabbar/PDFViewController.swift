//
//  PDFViewController.swift
//  YTeThongMinh
//
//  Created by DatTV on 6/5/20.
//  Copyright © 2020 Rikkeisoft. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: CustomNaviBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var pdfView: PDFView!
    var url: URL?
    var webview: WKWebView!
    var isFromVideoCall: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setHeaderView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
    }
    
    func setHeaderView(){
        headerView.title = self.title
        if isFromVideoCall {
            headerView.rightButtonFirst.setImage(UIImage(named: "icon_lose_message"), for: .normal)
            headerView.rightButtonFirst.isHidden = false
            headerView.rightButtonFirst.contentEdgeInsets = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
            headerView.rightButtonFirst.didTap = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            headerView.buttonBack.isHidden = true
        } else {
            headerView.isFromChat = true
            headerView.rightButtonFirst.isHidden = true
            headerView.buttonBack.isHidden = false
            headerView.didClickBack = { [weak self ] in
                self?.pop()
            }
        }
    }
    
    func setupWebView() {
        webview = WKWebView(frame: containerView.bounds)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.navigationDelegate = self
        containerView.addSubview(webview)
        if let url = url {
            webview.load(URLRequest(url: url))
        }
    }
    
    func viewPdf() {
        pdfView = PDFView(frame: containerView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        if let url = url {
            if let pdfDocument = PDFDocument(url: url) {
                pdfView.document = pdfDocument
            }
        }
        containerView.addSubview(pdfView)
    }
}

extension PDFViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("loaded")
        loadingIndicator.stopAnimating()
    }
}
