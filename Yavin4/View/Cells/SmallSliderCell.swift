//
//  SmallSliderCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/12/21.
//

import UIKit
import SDWebImage


//   +------------------------------------------------------+
//   | +---+                                                |
//   | |   |  TITLE                                         |
//   | +---+                                                |
//   | +---+                                                |
//   | |   |  TITLE                                         |
//   | +---+                                                |
//   | +---+                                                |
//   | |   |  TITLE                                         |
//   | +---+                                                |
//   | +---+                                                |
//   | |   |  TITLE                                         |
//   | +---+                                                |
//   +------------------------------------------------------+


class SmallSliderCell: UICollectionViewCell, ConfigurableCell {

    static let reuseIdentifier: String = "SmallSliderCell"
    let title = UILabel()
    let imageView = UIImageView()
    
    // ######################################################
    //MARK: CONFIGURE DATA METHOD(S)
    // ######################################################
    
    func configure(with item: Item) {
        title.text = item.title
        imageView.sd_setImage(with: NetworkService.getCellImageURL(with: item.image!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.textColor = .systemBlue
        
        imageView.sd_imageTransition = .fade
        imageView.sd_imageTransition?.duration = 0.2
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        let stackView = UIStackView(arrangedSubviews: [imageView, title])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 15
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("No storyboards")
    }
}
