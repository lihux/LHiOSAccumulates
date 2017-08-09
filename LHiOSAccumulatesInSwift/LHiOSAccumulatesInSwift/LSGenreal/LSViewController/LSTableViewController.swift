//
//  LSTableViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSTableViewController: UITableViewController {

    var accumulatesManager :LSAccumulateManager!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configWithTitle(_ title:String?, plistName: String) -> Void {
        self.title = title
        self.tableView.separatorStyle = .none
        let reuseID = self.tableViewCellResueIdentifier()!
        self.tableView.register(UINib.init(nibName: reuseID, bundle: nil), forCellReuseIdentifier: reuseID)
        self.accumulatesManager = LSAccumulateManager(plistFileName: plistName)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accumulatesManager.accumulates.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellResueIdentifier(), for: indexPath) as! LSTableViewCell
        cell.tag = indexPath.row
        let accumulate = self.accumulatesManager.accumulates[indexPath.row]
        cell.titleLabel.text = accumulate.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return LSSectionHeaderView.sectionHeaderView(title: self.title!, leftText: self.leftNavigatorItemText(), rightText: self.rightNavigatorItemText())
    }

    // MARK: - 子类需继承
    func tableViewCellResueIdentifier() -> String! {
        return "LSTableViewCell"
    }
    
    func leftNavigatorItemText() -> String! {
        return ""
    }
    func rightNavigatorItemText() -> String! {
        return ""
    }
    
}
