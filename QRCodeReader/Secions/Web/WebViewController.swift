//
//  WebViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/17/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class WebViewController: UIViewController {
    
    var url: URL

    /// Cookies handler
    private var cookiesHandler: (() -> ())?
    
    /// Handle cancel
    private var onClose: (()->())?
    
    /// Action button
    lazy var actionButton: UIButton = {
       
        let button = UIButton.button(style: .gradient)
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.setBackgroundColor(.white, forState: .normal)
        
        return button
    }()
    
    /// WebView container
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let config = WKWebViewConfiguration()
            
            config.userContentController = {
                let userContentController = WKUserContentController()
                
                if let cookies = APIManager.shared.cookies {
                    
                    let script = getJSCookiesString(cookies: cookies)
                    let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
                    userContentController.addUserScript(cookieScript)
                }
                
                return userContentController
            }()
            
            return config
        }())
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        
        /// Close button handler
        actionButton.setAction(block: { [unowned self] sender in
            self.onClose?()
        }, for: .touchUpInside)
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        actionButton.layer.cornerRadius = actionButton.frame.width / 2
        actionButton.layer.borderColor = UIColor.clear.cgColor
        actionButton.clipsToBounds = true
    }
    
    func layoutSetup() {
        
        view.backgroundColor = .white
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        view.addSubview(webView)
        webView.frame = view.frame
        
        /// Action button setup
        view.addSubview(actionButton)
        actionButton.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview().offset(-80)
            maker.width.height.equalTo(80)
            maker.centerX.equalToSuperview()
        }
    }
    
    ///Generates script to create given cookies
    public func getJSCookiesString(cookies: [HTTPCookie]) -> String {
        
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "';"
        }
        
        return result
    }
    
    func handleCookiesUdpate(_ completed: @escaping ()->()) {
        cookiesHandler = completed
    }
    
    func onClose(_ completed: @escaping ()->()) {
        onClose = completed
    }
}

// MARK: - Webview delegate
extension WebViewController: WKUIDelegate {
    
    /// Webview configuration setup
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension WebViewController: WKNavigationDelegate, UIScrollViewDelegate {
    /// Navigation setup
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
     
        webView.configuration.processPool = WKProcessPool()
        
        /// Check cookies
        if let cookies = HTTPCookieStorage.shared.cookies, cookies.count != 0 {
        
            APIManager.shared.cookies = cookies
            cookiesHandler?()
        }
    
        decisionHandler(.allow)
    }
}
