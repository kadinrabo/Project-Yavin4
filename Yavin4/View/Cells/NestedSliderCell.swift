//
//  NestedSliderCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/13/21.
//

import UIKit
import SDWebImage


//   +---------------------------------------------------+
//   | +------------+  +-------------+  +-------------+  |
//   | |            |  |             |  |             |  |
//   | |            |  |             |  |             |  |
//   | |            |  |             |  |             |  |
//   | |            |  |             |  |             |  |
//   | |            |  |             |  |             |  |
//   | +------------+  +-------------+  +-------------+  |
//   +---------------------------------------------------+


class NestedSliderCell: UICollectionViewCell, ConfigurableCell {
    
    static let reuseIdentifier = "NestedSliderCell"
    let imageView = UIImageView()
    
    // ######################################################
    //MARK: CONFIGURE DATA METHOD(S)
    // ######################################################
    
    func configure(with item: Item) {
        imageView.sd_setImage(with: NetworkService.getCellImageURL(with: item.image!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.sd_imageTransition = .fade
        imageView.sd_imageTransition?.duration = 0.2
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [imageView])
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("No storyboard")
    }
}
