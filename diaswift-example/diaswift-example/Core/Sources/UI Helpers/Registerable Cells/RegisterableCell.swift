//
//  RegisterableCell.swift
//  myTransitions
//
//  Created by John Patrick Teruel on 2/16/21.
//

import UIKit

protocol RegisterableCell{
    static var nibName: String { get }
    static var reusableIdentifier: String { get }
}

extension RegisterableCell where Self: UITableViewCell{
    static func register(toTable tableView: UITableView,
                         withReuseIdentifier identifier: String? = nil){
        tableView.register(UINib(nibName: nibName,
                                 bundle: nil),
                           forCellReuseIdentifier: identifier ?? reusableIdentifier)
    }
    
    static func register(toTables tableViews: [UITableView],
                         withReuseIdentifier identifier: String? = nil){
        tableViews.forEach { (tableView) in
            tableView.register(UINib(nibName: nibName,
                                     bundle: nil),
                               forCellReuseIdentifier: identifier ?? reusableIdentifier)
        }
    }
}

extension RegisterableCell where Self: UITableViewHeaderFooterView{
    static func register(toTable tableView: UITableView,
                         withReuseIdentifier identifier: String? = nil){
        tableView.register(UINib(nibName: nibName,
                                 bundle: nil),
                           forHeaderFooterViewReuseIdentifier: identifier ?? reusableIdentifier)
    }
    
    static func register(toTables tableViews: [UITableView],
                         withReuseIdentifier identifier: String? = nil){
        tableViews.forEach { (tableView) in
            tableView.register(UINib(nibName: nibName,
                                     bundle: nil),
                               forHeaderFooterViewReuseIdentifier: identifier ?? reusableIdentifier)
        }
    }
}

extension RegisterableCell where Self: UICollectionViewCell{
    static func register(toCollectionView collectionView: UICollectionView,
                         withReuseIdentifier identifier: String? = nil){
        collectionView.register(UINib(nibName: nibName, bundle: nil),
                                forCellWithReuseIdentifier: identifier ?? reusableIdentifier)
    }
    
    static func register(toCollectionViews collectionViews: [UICollectionView],
                         withReuseIdentifier identifier: String? = nil){
        collectionViews.forEach { (collectionView) in
            collectionView.register(UINib(nibName: nibName, bundle: nil),
                                    forCellWithReuseIdentifier: identifier ?? reusableIdentifier)
        }
    }
}
