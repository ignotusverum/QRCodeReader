//
//  EventCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    var event: Event? {
        didSet {
            
            guard let event = event else {
                return
            }
            
            /// Title
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 5

            titleLabel.attributedText = NSAttributedString(string: event.title, attributes: [NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.font: UIFont.type(type: .sharpSans, style: .bold, size: 18)])
            
            /// Timeframe
            let dateFormat = Date.startFormat(event.startDate, end: event.endDate)
            timeframeLabel.attributedText = NSAttributedString(string: dateFormat, attributes: [NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.font: UIFont.type(type: .markPro, size: 14)])
            
            /// Checkin
            let suffix = NSAttributedString(string: "CHECKED IN", attributes: [.font: UIFont.type(type: .markPro, style: .medium, size: 14), .foregroundColor: UIColor.defaultGreen])
            let result = NSMutableAttributedString(string: "\(event.numberOfCheckedInGuests.formattedWithSeparator) of \(event.numberOfGuests.formattedWithSeparator) ", attributes: [.font: UIFont.type(type: .markPro, style: .medium, size: 14)])
            result.append(suffix)
            checkinCountLabel.attributedText = result
            
            layoutSubviews()
        }
    }
    
    // MARK: UI elements
    private lazy var titleLabel: UILabel = { [unowned self] in
       
        let label = UILabel()
        label.numberOfLines = 3
        label.isWindlessable = true

        return label
    }()
    
    private lazy var timeframeLabel: UILabel = { [unowned self] in
        
        let label = UILabel()
        
        label.numberOfLines = 2
        label.isWindlessable = true
        
        return label
    }()
    
    private lazy var checkinCountLabel: UILabel = { [unowned self] in
       
        let label = UILabel()
        
        label.isWindlessable = true
        label.textAlignment = .right
        label.font = UIFont.type(type: .markPro, style: .medium, size: 14)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Title layout
        addSubview(titleLabel)
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(20)
            maker.height.equalTo(50)
            maker.right.equalToSuperview().offset(-20)
            maker.left.top.equalToSuperview().offset(20)
        }
        
        /// Timeframe label
        addSubview(timeframeLabel)
        timeframeLabel.sizeToFit()
        timeframeLabel.snp.updateConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
        }
        
        /// Checkin count layout
        addSubview(checkinCountLabel)
        checkinCountLabel.sizeToFit()
        checkinCountLabel.snp.updateConstraints { maker in
            maker.top.equalTo(timeframeLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(20)
            maker.right.bottom.equalToSuperview().offset(-20)
        }
    }
}
