//
//  NewsDetailVC.swift
//  NewsApp
//
//  Created by Zeynep Uzunsoy on 26.08.2023.
//

import UIKit
import WebKit

class NewsDetailVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var selectedNews : NewsItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let selectedNews = selectedNews, let newsLink = selectedNews.link, let url = URL(string: newsLink) {
            webView.navigationDelegate = self
            let request = URLRequest(url: url)
            webView.load(request)
        }
  
    }
    


}
