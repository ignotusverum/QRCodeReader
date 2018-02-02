//
//  GuestsViewController.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/26/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import Foundation

/// Utilities
import DZNEmptyDataSet
import JDStatusBarNotification

class GuestsViewController: UIViewController {
    
    /// Guests event
    var eventID: Int
    
    /// Datasource
    fileprivate var datasource: [Guest]?
    fileprivate var originalDatasource: [Guest]?
    
    /// Loading cell number
    var loadingCellCount = 8
    
    var searchInput: UITextField?
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(GuestCell.self, forCellWithReuseIdentifier: "\(GuestCell.self)")
        collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: "\(SearchViewCell.self)")
        
        collectionView.backgroundColor = .defaultGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Empty source delegate
        collectionView.emptyDataSetSource = self
        
        /// Backgrdoun image
        collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "default-background"))
        
        return collectionView
    }()
    
    // MARK: Initialization
    init(eventID: Int) {
        self.eventID = eventID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationImage(#imageLiteral(resourceName: "logo"))
        view.backgroundColor = .white
        
        /// Fetch data
        fetchData()
        
        /// Back
        setBackButton()
        
        /// Layout setup
        layoutSetup()
    }
    
    // MARK: Utilities
    private func layoutSetup() {
        
        /// Collection view layout
        view.addSubview(collectionView)
        collectionView.snp.updateConstraints { maker in
            maker.bottom.top.left.right.equalToSuperview()
        }
        
        /// Loader
        collectionView.windless
            .apply {
                $0.speed = 5
                $0.animationLayerOpacity = 0.5
            }
            .start()
    }
    
    private func fetchData() {
        GuestAdapter.fetchGuestsFor(eventID: eventID).then { [unowned self] response-> Void in
            self.datasource = response
            self.collectionView.reloadData()
            self.originalDatasource = response
            self.collectionView.windless.end()
            }.catch { [unowned self] error-> Void in
                self.datasource = []
                self.collectionView.reloadData()
                self.collectionView.windless.end()
                
                JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
        }
    }
    
    /// Loading timeout - disables loading animation and shows empty collectionView
    func setupLoadingTimeout() {
        let when = DispatchTime.now() + 15
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.loadingCellCount = 0
            self.collectionView.reloadData()
            self.collectionView.windless.end()
        }
    }
    
    /// Search
    private func searchTextChanged(_ text: String) {
        
        guard let originalDatasource = originalDatasource else {
            return
        }
        
        if text.count == 0 {
            self.datasource = originalDatasource
        } else {
            self.datasource = originalDatasource.filter { $0.fullName.lowercased().contains(text.lowercased()) }
        }
        
        collectionView.reloadSections([1])
    }
}

extension GuestsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let width: CGFloat = collectionView.frame.width - 40
        let height: CGFloat = indexPath.section == 0 ? 60 : 100
        
        return CGSize(width: width, height: height)
    }
}

extension GuestsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! GuestCell
        guard let guest = cell.guest else {
            return
        }
        
        let vc = GuestDetailsViewController(guest: guest)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension GuestsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return datasource == nil ?  loadingCellCount : datasource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchViewCell.self)", for: indexPath) as! SearchViewCell
            cell.delegate = self
            searchInput = cell.searchView.searchTextField
            
            return cell
        }
        
        let guestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GuestCell.self)", for: indexPath) as! GuestCell
        
        /// Safety check
        if let guests = datasource {
            let guest = guests[indexPath.row]
            guestCell.guest = guest
        }
        
        guestCell.addShadow()
        guestCell.delegate = self
        guestCell.clipsToBounds = true
        guestCell.backgroundColor = .white
        
        return guestCell
    }
}

extension GuestsViewController: GuestCellDelegate {
    func onCheckIn(cell: GuestCell) {
        /// Do networking call, update cell
        guard let guest = cell.guest, let agentID = Config.shared.currentAgent?.id else {
            return
        }
        
        let orderID = guest.orderItemGUID
        GuestAdapter.checkIn(orderID, agentID: agentID).then { response-> Void in
            
            cell.guest = response
            cell.checkInButton.hideLoader()
            }.catch { error in
                JDStatusBarNotification.show(withStatus: error.localizedDescription, dismissAfter: 2.0, styleName: AppDefaultAlertStyle)
                cell.checkInButton.hideLoader()
        }
    }
}

// MARK: - Empty datasource
extension GuestsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No guests assigned to this event", attributes: [.font: UIFont.type(type: .markPro, size: 25), .foregroundColor: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Please add guests", attributes: [.font: UIFont.type(type: .markPro, size: 15), .foregroundColor: UIColor.lightGray])
    }
}

extension GuestsViewController: SearchViewCellDelegate {
    func onClearButton() {
        searchTextChanged("")
    }
    
    func textDidChange(_ text: String?) {
        searchTextChanged(text ?? "")
    }
}
