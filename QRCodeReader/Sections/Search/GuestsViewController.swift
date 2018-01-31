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
    
    /// Search view
    lazy var searchView = SearchView()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(GuestCell.self, forCellWithReuseIdentifier: "\(GuestCell.self)")
        
        collectionView.backgroundColor = .defaultGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Empty source delegate
        collectionView.emptyDataSetSource = self
        
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
        
        /// Setup search logic
        searchSetup()
    }
    
    // MARK: Utilities
    private func layoutSetup() {
        
        /// Search view
        view.addSubview(searchView)
        searchView.snp.updateConstraints { maker in
            maker.height.equalTo(55)
            maker.top.left.right.equalToSuperview()
        }
        
        /// Collection view layout
        view.addSubview(collectionView)
        collectionView.snp.updateConstraints { maker in
            maker.top.equalToSuperview().offset(55)
            maker.bottom.left.right.equalToSuperview()
        }
        
        /// Loader
        collectionView.windless
            .apply {
                $0.speed = 5
                $0.animationLayerOpacity = 0.5
            }
            .start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchView.addBottomBorder()
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
    
    private func searchSetup() {
        searchView.onClearButton { [unowned self] in
            self.searchTextChanged("")
        }
        
        searchView.textDidChange { [unowned self] text in
            self.searchTextChanged(text ?? "")
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
        
        collectionView.reloadData()
    }
}

extension GuestsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        if DeviceType.IS_IPHONE_5 {
            return CGSize(width: collectionView.frame.width / 2 - 20, height: collectionView.frame.height / 1.5)
        } else if DeviceType.IS_IPHONE_6 {
            return CGSize(width: collectionView.frame.width / 2 - 20, height: collectionView.frame.height / 2)
        }
        
        return CGSize(width: collectionView.frame.width / 2 - 20, height: collectionView.frame.height / 2.3)
    }
}

extension GuestsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource == nil ?  loadingCellCount : datasource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
