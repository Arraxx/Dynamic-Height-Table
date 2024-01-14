//
//  QuoteTableViewCell.swift
//  dynamicHeightTable
//
//  Created by Arrax on 14/01/24.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!

    @IBOutlet weak var wikiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
