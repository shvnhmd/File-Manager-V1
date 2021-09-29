//
//  FavouriteTableViewCell.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/25/20.
//

import UIKit

protocol FavouriteCellDlegate: AnyObject {
    func favouriteCellButtonTapped(cell: FavouriteTableViewCell)
}

class FavouriteTableViewCell: UITableViewCell {

    weak var delegate : FavouriteCellDlegate?
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var favouriteFolderImage: UIImageView!
    
    static let idetifier = "FavouriteTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FavouriteTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favouriteButtonPressed(_ sender: Any) {
    
        delegate?.favouriteCellButtonTapped(cell: self)
    
    }
}
