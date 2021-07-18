//
//  Cell-Protocol.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/29/21.
//

protocol ConfigurableCell {
    static var reuseIdentifier: String { get }
    func configure(with cell: Item)
}
