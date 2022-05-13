//
//  DetailView.swift
//  EasyBrowserS
//
//  Created by Josue Hernandez on 1/3/22.
//

import Foundation
import UIKit
import WebKit

class DetailView: UIViewController, WKNavigationDelegate {
    
    // Mark :- Properties
    var webView: WKWebView = {
        var wk = WKWebView()
        return wk
    }()
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    let webSites = ["google.com", "apple.com", "raywenderlich.com"]
    var progressView: UIProgressView!
    var urlStr = "http://www.google.com"
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    func configure(with urlSite: String) {
           self.urlStr = urlSite
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openTapped))
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goBack))
        let forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goForward))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh,
                                      target: webView,
                                      action: #selector(webView.reload))
        self.backButton = backButton
        self.forwardButton = forwardButton
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [backButton, forwardButton, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        let url = URL(string: "https://www.\(urlStr)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        self.backButton?.isEnabled = self.webView.canGoBack
        self.forwardButton?.isEnabled = self.webView.canGoForward
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack),
                                 options: .new,
                                 context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward),
                                 options: .new,
                                 context: nil)
    }


    @objc func openTapped(){
        let alert = UIAlertController(title: "Open page ... ",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        for webSite in webSites {
            alert.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // useful for ipads, tells where this action sheet be anchored
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let pageUrl = URL(string: "https://www.\(action.title!)")!
        webView.load(URLRequest(url: pageUrl))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in webSites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        if keyPath == "estimatedProgress" && progressView.progress >= 1.0 {
            progressView.progressTintColor = .systemGray
        }
        
        if let _ = object as? WKWebView {
           if keyPath == #keyPath(WKWebView.canGoBack) {
               self.backButton?.isEnabled = self.webView.canGoBack
           } else if keyPath == #keyPath(WKWebView.canGoForward) {
               self.forwardButton?.isEnabled = self.webView.canGoForward
           }
        }
        
    }
    
}

