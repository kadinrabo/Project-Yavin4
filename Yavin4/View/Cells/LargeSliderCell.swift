//
//  LargeSliderCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/12/21.
//

import UIKit
import SDWebImage


//   +------------------------------------------------------+
//   | +-------------------+ +------------------+ +---------|
//   | | TAG               | | TAG              | | TAG     |
//   | | TITLE             | | TITLE            | | TITLE   |
//   | +-------------------+ +------------------+ +---------|
//   | +-------------------+ +------------------+ +---------|
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | |                   | |                  | |         |
//   | +-------------------+ +------------------+ +---------|
//   +------------------------------------------------------+


class LargeSliderCell: UICollectionViewCell, ConfigurableCell {
    
    static let reuseIdentifier: String = "LargeSliderCell"
    let tagline = UILabel()
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    // ######################################################
    //MARK: CONFIGURE DATA METHOD(S)
    // ######################################################
    
    func configure(with item: Item) {
        tagline.text = item.tag?.uppercased()
        title.text = item.title
        imageView.sd_setImage(with: NetworkService.getCellImageURL(with: item.image!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################

    override init(frame: CGRect) {
        super.init(frame: frame)

        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemBlue

        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitle.textColor = .secondaryLabel
        
        imageView.sd_imageTransition = .fade
        imageView.sd_imageTransition?.duration = 0.2
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [tagline, title, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.setCustomSpacing(10, after: subtitle)
    }
    required init?(coder: NSCoder) {
        fatalError("No storyboard")
    }
}
