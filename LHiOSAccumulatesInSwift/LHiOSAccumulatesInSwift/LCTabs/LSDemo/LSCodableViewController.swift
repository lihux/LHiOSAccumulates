//
//  LSCodableViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LSCodableViewController: LSViewController, URLSessionDelegate, URLSessionDataDelegate {
    var session: URLSession!
    let isbn = "9787511228192"
//    let isbn = "9787111453833"
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    @IBAction func didTapOnFetchButton(_ sender: Any) {
        fetchBookInfo(isbn: isbn)
    }
    func fetchBookInfo(isbn:String) -> Void {
        session.dataTask(with: URL(string: "https://api.douban.com/v2/book/isbn/\(isbn)")!).resume()
    }
    
    // MARK: URLSessionDelegate
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error!.localizedDescription)
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(challenge)
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust:challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(data)
        let jsonDecoder = JSONDecoder()
        do {
            let book = try jsonDecoder.decode(LSBook.self, from: data)
            print(book)
        } catch let error as NSError {
            print("\(error.localizedDescription):\n\(error.userInfo)")
        }
    }
}
