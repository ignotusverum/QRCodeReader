//
//  FevoAlertView.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/29/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

enum OverlayActionStyle {
    case button
    case cancel
}

struct OverlayAction {
    var title: String
    var style: OverlayActionStyle
    
    var handler: (()->())
}

class ActionOverlay: UIView {
    
    var title: String
    var subTitle: String
    
    lazy var subTitleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.type(type: .markPro)
        
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.type(type: .sharpSans, style: .bold, size: 30)
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        
        /// Collection layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ActionOverlayCell.self, forCellWithReuseIdentifier: "\(ActionOverlayCell.self)")
        
        return collection
    }()
    
    private var overlayActions: [OverlayAction] = []
    
    lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    lazy var containerView = UIView()
    
    init(title: String, subTitle: String) {
        
        self.title = title
        self.subTitle = subTitle
        
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(blurView)
        blurView.frame = frame
        
        addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 8
        
        titleLabel.text = title
        containerView.addSubview(titleLabel)
        
        subTitleLabel.text = subTitle
        containerView.addSubview(subTitleLabel)
        
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(15)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(40)
            maker.bottom.equalTo(subTitleLabel.snp.top)
        }
        
        subTitleLabel.sizeToFit()
        subTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        containerView.addSubview(collectionView)
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(overlayActions.count * 70)
            maker.bottom.equalTo(containerView)
        }
        
        containerView.snp.updateConstraints { maker in
            maker.center.equalToSuperview()
            maker.left.equalTo(40)
            maker.right.equalTo(-40)
        }
    }
    
    func addAction(action: OverlayAction) {
        overlayActions.append(action)
        collectionView.reloadData()
    }
    
    func present() {
        
        let window = AppDelegate.shared.window!
        if !window.subviews.contains(self) {
            window.addSubview(self)
        }
        
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func dismiss() {
        
        alpha = 1.0
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.alpha = 0.0
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Utilities
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Dismissing logic
        if let touch = touches.first {
            
            // Checking if touched view background effect
            if touch.view == blurView {
                // Remove view
                dismiss()
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
}

// MARK: - CollectionView Delegate
extension ActionOverlay: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ActionOverlayCell
        
        cell.action.handler()
        dismiss()
    }
}

// MARK: - CollectionView Datasource
extension ActionOverlay: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
}

// MARK: - CollectionView Datasource
extension ActionOverlay: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return overlayActions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ActionOverlayCell.self)", for: indexPath) as! ActionOverlayCell
        
        let action = overlayActions[indexPath.row]
        cell.action = action
        
        return cell
    }
}

