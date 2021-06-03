//
//  SettingsView.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/17/21.
//

import UIKit
import Firebase


// ######################################################
//MARK: CONFIGURE HIERARCHY METHOD(S)
// ######################################################

extension SettingsController {
    
    func configureHierarchy() {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
    }
}


// ######################################################
//MARK: CONFIGURE CELLS METHOD(S)
// ######################################################

extension SettingsController {
    
    func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.subtitle
            content.secondaryTextProperties.color = .systemBlue
            content.textProperties.numberOfLines = 2
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader)  { [unowned self] (headerView, elementKind, indexPath) in
            
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            var header = headerView.defaultContentConfiguration()
            header.text = headerItem.title
            
            header.textProperties.font = .boldSystemFont(ofSize: 16)
            header.textProperties.color = .systemBlue
            header.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            headerView.contentConfiguration = header
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
}
