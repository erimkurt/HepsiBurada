//
//  ListTableViewCell.swift
//  Hepsiburada
//
//  Created by macbookair on 21.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.changeColorOfIcon(color: UIColor.lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
