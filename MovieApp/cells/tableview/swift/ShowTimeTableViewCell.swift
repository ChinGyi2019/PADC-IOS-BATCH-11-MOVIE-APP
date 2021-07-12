//
//  ShowTimeTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 29/01/2021.
//

import UIKit

class ShowTimeTableViewCell: UITableViewCell {
   
    @IBOutlet weak var lblSeeMore: UILabel!
    @IBOutlet weak var viewForBackground: UIView!

  
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSeeMore.underLineText(text: "SEE MORE", stroke: 2)
        
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.backgroundColor = UIColor(named: "color_primary")
        }
    }
    
}
