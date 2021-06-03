//
//  MediumPanelCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/14/21.
//

import UIKit
import SDWebImage


//   +------------------------------------------------------+
//   | +--------------------------------------------------+ |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | |                                                  | |
//   | +--------------------------------------------------+ |
//   |                                                      |
//   | Lorem ipsum dolor sit amet, consectetur adipiscing   |
//   | elit, sed do eiusmod tempor incididunt ut labore et  |
//   | dolore magna aliqua. Nec nam aliquam sem et tortor.  |
//   | Aliquam nulla facilisi cras fermentum odio eu. Quisqu|
//   | id diam vel quam elementum pulvinar etiam. Sagittis  |
//   | volutpat odio facilisis mauris sit amet massa vitae. |
//   |                                                      |
//   +------------------------------------------------------+


class MediumPanelCell: UICollectionViewCell, ConfigurableCell {
    
    static let reuseIdentifier: String = "MediumPanelCell"
    let imageView = UIImageView()
    let text = UILabel()
    
    // ######################################################
    //MARK: CONFIGURE DATA METHOD(S)
    // ######################################################
    
    func configure(with item: Item) {
        imageView.sd_setImage(with: NetworkService.getCellImageURL(with: item.image!), placeholderImage: UIImage(named: "placeholder"))
        text.text = item.description
    }
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        text.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        text.textColor = .label
        text.numberOfLines = 0
        
        imageView.sd_imageTransition = .fade
        imageView.sd_imageTransition?.duration = 0.2
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        let stackView = UIStackView(arrangedSubviews: [imageView, text])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        contentView.addSubview(stackView)

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
