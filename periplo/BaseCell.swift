//
//  BaseCell.swift
//  periplo
//
//  Created by Juan José Castro on 7/19/17.
//  Copyright © 2017 Juan José Castro. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // to be overridden
    }
}
