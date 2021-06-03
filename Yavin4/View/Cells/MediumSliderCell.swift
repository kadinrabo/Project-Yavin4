//
//  MediumSliderCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/12/21.
//

import UIKit
import SDWebImage


//   +------------------------------------------------------+
//   | +-------+                                            |
//   | |       |  TITLE                                     |
//   | |       |  SUBTITLE                                  |
//   | |       |                                            |
//   | +-------+                                            |
//   | +-------+                                            |
//   | |       |  TITLE                                     |
//   | |       |  SUBTITLE                                  |
//   | |       |                                            |
//   | +-------+                                            |
//   | +-------+                                            |
//   | |       |  TITLE                                     |
//   | |       |  SUBTITLE                                  |
//   | |       |                                            |
//   | +-------+                                            |
//   +------------------------------------------------------+


class MediumSliderCell: UICollectionViewCell, ConfigurableCell {
    
    static let reuseIdentifier: String = "MediumSliderCell"
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    // ######################################################
    //MARK: CONFIGURE DATA METHOD(S)
    // ######################################################
    
    func configure(with item: Item) {
        title.text = item.title
        subtitle.text = item.subtitle
        imageView.sd_setImage(with: NetworkService.getCellImageURL(with: item.image!), placeholderImage: UIImage(named: "placeholder"))
    }
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label

        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel

        imageView.sd_imageTransition = .fade
        imageView.sd_imageTransition?.duration = 0.2
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical

        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)

        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("No storyboard")
    }
}
