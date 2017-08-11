//
//  LSTableViewController.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSTableViewController: UITableViewController, LSSectionHeaderViewDelegate {

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
        let leftText = self.leftNavigatorItemText()
        let rightText = self.rightNavigatorItemText()
        return LSSectionHeaderView.sectionHeaderView(delegate: self, title: self.title!, leftText: leftText, rightText: rightText)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中了第\(indexPath.row)行")
        let accumulate = self.accumulatesManager.accumulates[indexPath.row]
        let viewController = LSUtils.viewControllerForAccumulate(accumulate: accumulate)
        if let vc = viewController {
            vc.title = accumulate.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: LSSectionHeaderViewDelegate
    func sectionHeaderView(_ sectionHeaderView: LSSectionHeaderView, tappedOnLeftButton leftButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: 子类需继承
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
