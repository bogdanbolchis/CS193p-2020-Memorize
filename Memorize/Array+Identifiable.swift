//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Bogdan Bolchis on 27/05/2020.
//  Copyright © 2020 Bogdan Bolchis. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        return firstIndex(where: { (card) -> Bool in card.id == matching.id })
    }
}
