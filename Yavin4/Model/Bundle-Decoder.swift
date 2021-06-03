//
//  Bundle-Decoder.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/29/21.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from urlString: String) -> T {  // Method must quit app if anything fails
        guard let url = URL(string: urlString) else {
            fatalError("Failed to load server")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load json from server")
        }
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode json from server")
        }
        return loaded
    }
}
