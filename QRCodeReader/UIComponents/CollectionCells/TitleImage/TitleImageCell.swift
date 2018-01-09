//
//  TitleImageCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

class TitleImageCell: UICollectionViewCell {
    
    var title: String!
    var image: UIImage!
    
    private var titleLabel: UILabel = {
       
        let label = UILabel()
        
        return label
    }()
}
