//
//  ImageTableViewCell.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/29/20.
//

import UIKit

protocol FavouriteCellDelegate: AnyObject {
    func favButtonTapped(cell: ImageTableViewCell)
}

class ImageTableViewCell: UITableViewCell {
    weak var delegate : FavouriteCellDelegate?
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var folderLabel: UILabel!
    @IBOutlet weak var folderImage: UIImageView!
    

    static let idetifier = "ImageTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ImageTableViewCell", bundle: nil)
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        print("view appeared")
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   @IBAction func favButtonPressed(_ sender: Any) {
    
    self.delegate?.favButtonTapped(cell: self)
        print("tappednow")
    
    }
}
