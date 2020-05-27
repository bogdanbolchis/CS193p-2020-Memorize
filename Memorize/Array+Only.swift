//
//  Array+Only.swift
//  Memorize
//
//  Created by Bogdan Bolchis on 27/05/2020.
//  Copyright © 2020 Bogdan Bolchis. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
