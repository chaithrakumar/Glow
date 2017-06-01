//
//  ContentListCell.swift
//  GlowMe
//
//  Created by chaithra Kumar on 3/27/17.
//  Copyright © 2017 Henry Mason. All rights reserved.
//

import UIKit

class ContentListCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var TypeLabel: UILabel!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(5, 5, 5, 5))
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
