//
//  ContactTableViewCell.swift
//  ContatosIP67
//
//  Created by ios6584 on 11/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        photoImageView.backgroundColor = UIColor.lightGray
        photoImageView.layer.cornerRadius = 25.0
        photoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
