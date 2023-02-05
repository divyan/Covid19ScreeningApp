//
//  CustomTableViewCell.swift
//  naik5500_final
//
//  Created by Divya Naiken on 2021-04-12.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    //MARK: UI Properties
    
    //Views, Imageviews
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var resultImage: UIImageView!
    
    //Labels
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
