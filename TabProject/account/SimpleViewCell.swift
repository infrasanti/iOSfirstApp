//
//  SimpleViewCell.swift
//  TableMultiCell
//
//  Created by Santiago Ramirez on 29/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class SimpleViewCell: UITableViewCell {
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBOutlet var textView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: Attribute) {
        textView.text = data.value
    }
    
    public func setData(_ data: ProfileViewModelAboutItem) {
        textView.text = data.about
    }
    public func setData(_ data: ProfileViewModelEmailItem) {
        textView.text = data.email
    }
}
