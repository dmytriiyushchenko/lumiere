//
//  WebView.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.07.2026.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))       
    }
}
