//
//  HeaderCell.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/12/21.
//

import UIKit


//   +------------------------------------------------------+
//   | +--------------------------------------------------+ |
//   | |                                                  | |
//   | | TAG                                              | |
//   | | TITLE                                            | |
//   | | SUBTITLE                                         | |
//   | |                                                  | |
//   | +--------------------------------------------------+ |
//   +------------------------------------------------------+


class HeaderCell: UICollectionReusableView {
    
    static let reuseIdentifier = "HeaderCell"
    let title = UILabel()
    let subtitle = UILabel()
    
    // ######################################################
    //MARK: INITIALIZE STYLE METHOD(S)
    // ######################################################

    override init(frame: CGRect) {
        super.init(frame: frame)

        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))

        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 2

        let stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("No storyboard")
    }
}
