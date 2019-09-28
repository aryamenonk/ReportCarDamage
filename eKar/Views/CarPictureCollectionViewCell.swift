//
//  CarPictureCollectionViewCell.swift
//  eKar
//
//  Created by Arya Menon K on 9/27/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit

class CarPictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sideImageView: UIImageView?
    @IBOutlet weak var sideDescriptionLabel: UILabel?
    
    var reportImageModel = ReportImageModel() {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBorder()
        setCornerRaduis()
        configureCell()
    }

    func configureCell() {
        
        //set image, if no image set the place holder
        sideImageView?.image = reportImageModel.image ?? UIImage(named: "placeholderImage")
        
        guard let side = reportImageModel.side else { return }
        // set label text
        sideDescriptionLabel?.text = side.rawValue.capitalized + "\n" + "Side"
    }
}
