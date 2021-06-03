//
//  WorkoutView.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/17/21.
//

import UIKit


// ######################################################
//MARK: CONFIGURE HIERARCHY METHOD(S)
// ######################################################

extension WorkoutController {
    
    func configureHierarchy() {
        if let layout = createCompositionalLayout() {
            self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "Layout error @ configureHierarchy() in WorkoutView.swift"
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
            case "MediumPanelCell":
                return self.createMediumPanelCellSection(using: layoutSection)
            case "SupplementarySliderCell":
                return self.createSupplementarySliderCellSection(using: layoutSection)
            default:
                return nil
            }
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createMediumPanelCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.7))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return layoutSection
    }
    
    func createSupplementarySliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}


// ######################################################
//MARK: CONFIGURE CELLS METHOD(S)
// ######################################################

extension WorkoutController {
    
    func createDataSource() {
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
        collectionView.register(MediumPanelCell.self, forCellWithReuseIdentifier: MediumPanelCell.reuseIdentifier)
        collectionView.register(SupplementarySliderCell.self, forCellWithReuseIdentifier: SupplementarySliderCell.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch self.sections[indexPath.section].type {
            case "MediumPanelCell":
                return Helper.configure(MediumPanelCell.self, with: item, for: indexPath, collectionView: collectionView)
            case "SupplementarySliderCell":
                return Helper.configure(SupplementarySliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            default:
                return nil
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.reuseIdentifier, for: indexPath) as? HeaderCell else {
                return nil
            }
            guard let firstCell = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstCell) else { return nil }
            if section.title!.isEmpty { return nil }

            sectionHeader.title.text = section.title
            sectionHeader.subtitle.text = section.subtitle
            return sectionHeader
        }
    }
}
