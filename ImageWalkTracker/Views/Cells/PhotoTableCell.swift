//
//  PhotoTableCell.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

class PhotoTableCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var imageContentView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageContentView.layer.borderWidth = 0.5
        imageContentView.layer.borderColor = UIColor.lightGray.cgColor
        imageContentView.contentMode = .scaleAspectFill
    }
    
    // MARK: - UI Setup
    func set(_ image: UIImage?) {
        imageContentView.image = image
    }
}
