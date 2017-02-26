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
        self.accumulatesManager = LSAccumulateManager(plistFileName: self.plistFileName()!)
    }

    func plistFileName() -> String? {
        return nil
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accumulatesManager.accumulates.count
    }
//    LCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellResueIdentifier] forIndexPath:indexPath];
//    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
//    [cell configCellWithAccumulate:accumulate withIndexPatch:indexPath];
//    cell.delegate = self;

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.tableViewCellResueIdentifier(), forIndexPath: indexPath)
        return cell
    }
    
    // MARK: - 子类需继承
    func tableViewCellResueIdentifier() -> String! {
        return "LSTableViewCellSmallSize"
    }
    
    func leftNavigatorItemText() -> String! {
        return ""
    }
    func rightNavigatorItemText() -> String! {
        return ""
    }
    
}
