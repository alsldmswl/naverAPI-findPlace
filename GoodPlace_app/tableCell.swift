//
//  tableCell.swift
//  GoodPlace_app
//
//  Created by eun-ji on 2023/03/07.
//

import Foundation
import UIKit

class tableCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
}
