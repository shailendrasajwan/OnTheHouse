//
//  FAQWebViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 13/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class FAQWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://www.on-the-house.org/faq")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
