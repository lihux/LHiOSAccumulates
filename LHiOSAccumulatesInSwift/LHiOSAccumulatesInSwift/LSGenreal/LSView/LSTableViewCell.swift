//
//  LSTableViewCell.swift
//  LHiOSAccumulatesInSwift
//
//  Created by lihui on 16/1/24.
//  Copyright © 2016年 Lihux. All rights reserved.
//

import UIKit

class LSTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var headImageView:UIImageView!
    func configCell(accumulate: LSAccumulate) {
        self.titleLabel.text = accumulate.title
//        self.contentLabel.text = accumulate.content
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
