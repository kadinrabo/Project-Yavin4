//
//  HomeView.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/17/21.
//

import UIKit


// ######################################################
//MARK: CONFIGURE HIERARCHY METHOD(S)
// ######################################################

extension HomeController {
    
    func configureHierarchy() {
        if let layout = createCompositionalLayout() {
            self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "Layout error @ configureHierarchy() in HomeView.swift"
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout? {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let layoutSection = self.sections[sectionIndex]

            switch layoutSection.type {
            case "LargeSliderCell":
                return self.createLargeSliderCellSection(using: layoutSection)
            case "MediumSliderCell":
                return self.createMediumSliderCellSection(using: layoutSection)
            case "SmallSliderCell":
                return self.createSmallSliderCellSection(using: layoutSection)
            case "BigImageSliderCell":
                return self.createBigImageSliderCellSection(using: layoutSection)
            default:
                return nil
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createLargeSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.60),
            heightDimension: .fractionalHeight(0.40))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return layoutSection
    }

    func createMediumSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
        return layoutSection
    }

    func createSmallSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(200))  // unused
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return layoutSection
    }
    
    func createBigImageSliderCellSection(using section: Section) -> NSCollectionLayoutSection {
        let layoutItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.90),
            heightDimension: .fractionalHeight(0.6))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
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

extension HomeController {
    
    func createDataSource() {
        
        // Registration
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
        collectionView.register(LargeSliderCell.self, forCellWithReuseIdentifier: LargeSliderCell.reuseIdentifier)
        collectionView.register(MediumSliderCell.self, forCellWithReuseIdentifier: MediumSliderCell.reuseIdentifier)
        collectionView.register(SmallSliderCell.self, forCellWithReuseIdentifier: SmallSliderCell.reuseIdentifier)
        collectionView.register(BigImageSliderCell.self, forCellWithReuseIdentifier: BigImageSliderCell.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch self.sections[indexPath.section].type {
            case "LargeSliderCell":
                return Helper.configure(LargeSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            case "MediumSliderCell":
                return Helper.configure(MediumSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            case "SmallSliderCell":
                return Helper.configure(SmallSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            case "BigImageSliderCell":
                return Helper.configure(BigImageSliderCell.self, with: item, for: indexPath, collectionView: collectionView)
            default:
                return nil
            }
        }

        // Configure Supplementary View
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
