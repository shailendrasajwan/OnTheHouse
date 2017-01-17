//
//  AffiliateLinkWebViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 18/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class AffiliateLinkWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.url {
            let webUrl = NSURL(string: url)
            let request = NSURLRequest(URL: webUrl!)
            webView.loadRequest(request)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func navigateToPreviousPage() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
