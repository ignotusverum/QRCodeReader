//
//  SeachCell.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 2/2/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

protocol SearchViewCellDelegate {
    func onClearButton()
    func textDidChange(_ text: String?)
}

class SearchViewCell: UICollectionViewCell {
    
    /// Delegate
    var delegate: SearchViewCellDelegate?
    
    /// Search
    lazy var searchView: SearchView = {
        
        let view = SearchView()
        view.backgroundColor = UIColor.white
        view.placeholder = "Search for name, order ID or ticket type"
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .white
        
        searchView.onClearButton { [unowned self] in
            self.delegate?.onClearButton()
        }
        
        searchView.textDidChange { [unowned self] text in
            self.delegate?.textDidChange(text)
        }
        
        addSubview(searchView)
        searchView.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }
    
}
