//
//  StagesView.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/17/21.
//

import UIKit


// ######################################################
//MARK: CONFIGURE HIERARCHY METHOD(S)
// ######################################################

extension StagesController {
    
    func configureHierarchy() {
        if let layout = createCompositionalLayout() {
            self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "Layout error @ configureHierarchy() in StagesView.swift"
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout? {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            
            let layoutSection = self.sections[sectionIndex]
            switch layoutSection.type {
            case "BigImageSliderCell":
                return self.createBigImageSliderCellSection(using: layoutSection)
            case "NestedSliderCell":
                return self.createNestedSliderCellSection(using: layoutSection)
            default:
                return nil
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createNestedSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let leftItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.46),
            heightDimension: .fractionalHeight(1.0))
        let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
        leftItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let rightItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.54),
            heightDimension: .fractionalHeight(1.0))
        let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
        rightItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let topSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.80),
            heightDimension: .fractionalHeight(0.15))
        let top = NSCollectionLayoutGroup.horizontal(layoutSize: topSize, subitems: [leftItem, rightItem])

        let layoutSection = NSCollectionLayoutSection(group: top)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return layoutSection
    }
    
    func createBigImageSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.65))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return layoutSection
    }
}


// ######################################################
//MARK: CONFIGURE CELLS METHOD(S)
// ######################################################

extension StagesController {
    
    func createDataSource() {
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
        collectionView.register(BigImageSliderCell.self, forCellWithReuseIdentifier: BigImageSliderCell.reuseIdentifier)
        collectionView.register(NestedSliderCell.self, forCellWithReuseIdentifier: NestedSliderCell.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch self.sections[indexPath.section].type {
            case "NestedSliderCell":
                return Helper.configure(NestedSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            case "BigImageSliderCell":
                return Helper.configure(BigImageSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            default:
                return nil
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath) as? HeaderCell else { return nil }
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            if section.title!.isEmpty { return nil }
            
            sectionHeader.title.text = section.title
            sectionHeader.subtitle.text = section.subtitle
            return sectionHeader
        }
    }
}
