//
//  TitleCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

class TitleCell: UICollectionViewCell, DividerCellProtocol, TitleCellProtocol, AccessoryCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Simple title
    var text: String! {
        didSet {
            
            /// Title
            titleLabel.text = text.capitalizeFirst()
            print(text.capitalizeFirst())
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Title layout
        titleLayout()
        
        /// Accessory image
        accessoryLayout()
    }
}

