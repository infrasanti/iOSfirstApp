//
//  TestViewCell.swift
//  TableMultiCell
//
//  Created by Santiago Ramirez on 28/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class TestViewCell: UITableViewCell {

    @IBOutlet var picture: UIImageView!
    @IBOutlet var textView: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picture.layer.masksToBounds = false
        picture.layer.cornerRadius = picture.frame.size.height/2
        picture.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: ProfileViewModelNameItem) {
        textView.text = data.userName
        picture.image = UIImage(named: data.pictureUrl)
    }
    
    public func setData(_ data: Friend) {
        textView.text = data.name
        if let pictureUrl = data.pictureUrl {
            picture.image = UIImage(named: pictureUrl)
    
        }
    }
}
