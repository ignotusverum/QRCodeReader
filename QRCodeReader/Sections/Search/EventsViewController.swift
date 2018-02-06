//
//  EventsViewController: UI.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/25/18.
//  Copyright © 2018 Fevo. All rights reserved.
//

import UIKit
import Foundation

/// Loading
import Windless

/// Utilities
import PromiseKit
import DZNEmptyDataSet

class EventsViewController: UIViewController {
    
    /// Agent for search
    var agent: Agent
    
    /// Collection setup
    lazy private var collectionView: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "\(EventCell.self)")
        
        collectionView.backgroundColor = .defaultGray
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Empty source delegate
        collectionView.emptyDataSetSource = self
        
        /// Background view
        collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "default-background"))
        
        return collectionView
    }()
    
    /// Events datasource
    var datasource: [Event]?
    
    /// Loading cell number
    var loadingCellCount = 5
    
    // MARK: Init
    init(agent: Agent) {
        self.agent = agent
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
        
        /// Layout
        setupLayout()
        
        /// Loading timeout
        setupLoadingTimeout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    // MARK: Utilities
    private func fetchData() {
        /// Create promise iterator
        var eventIDIterator = agent.eventIDs.makeIterator()
        let generator = AnyIterator<Promise<Event>> {
            
            guard let eventID = eventIDIterator.next() else {
                return nil
            }
            
            return EventAdapter.fetch(eventID: eventID)
        }
        
        /// Wait untill other promises fulfilled
        when(fulfilled: generator, concurrently: 3).then { [unowned self] response-> Void in
            
            self.datasource = response
            self.collectionView.windless.end()
            self.collectionView.reloadData()
            }.catch { [unowned self] error-> Void in
                self.datasource = []
                self.collectionView.reloadData()
                self.collectionView.windless.end()
                
                NavigationStatusView.showError(controller: self, subtitle: error.localizedDescription)
        }
    }
    
    private func setupLayout() {
        
        /// Collection view layout
        view.addSubview(collectionView)
        collectionView.snp.updateConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
        
        /// Loader
        collectionView.windless
            .apply {
                $0.speed = 5
                $0.animationLayerOpacity = 0.5
            }
            .start()
    }
    
    /// Loading timeout - disables loading animation and shows empty collectionView
    func setupLoadingTimeout() {
        let when = DispatchTime.now() + 15
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            
            self?.loadingCellCount = 0
            self?.collectionView.reloadData()
            self?.collectionView.windless.end()
        }
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 180)
    }
}

extension EventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! EventCell
        guard let event = cell.event else {
            return
        }
        
        let vc = GuestsViewController(eventID: event.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EventsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource == nil ?  loadingCellCount : datasource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(EventCell.self)", for: indexPath) as! EventCell
        
        /// Safety check
        if let events = datasource {
            let event = events[indexPath.row]
            eventCell.event = event
        }
    
        eventCell.addShadow()
        eventCell.addGradientBorder()
        eventCell.backgroundColor = .white
    
        return eventCell
    }
}

// MARK: - Empty datasource
extension EventsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No events assgned to you", attributes: [.font: UIFont.type(type: .markPro, size: 25), .foregroundColor: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Please create an event", attributes: [.font: UIFont.type(type: .markPro, size: 15), .foregroundColor: UIColor.lightGray])
    }
}
