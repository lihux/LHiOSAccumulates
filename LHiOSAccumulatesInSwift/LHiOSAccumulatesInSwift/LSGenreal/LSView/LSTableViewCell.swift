//
//  LSTableViewCell.swift
//  LHiOSAccumulatesInSwift
//
//  Created by 李辉 on 2017/8/9.
//  Copyright © 2017年 Lihux. All rights reserved.
//

import UIKit

class LSTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
