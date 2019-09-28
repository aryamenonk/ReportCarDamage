//
//  ReportPictureModel.swift
//  eKar
//
//  Created by Arya Menon K on 9/27/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit

// the number of cells displayed in the collection view in th esame order.
enum Side: String,CaseIterable {
    case front
    case back
    case left
    case right
}

struct ReportImageModel: Equatable {
    var image: UIImage?
    var side: Side?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        // to equate based on side inly.
        lhs.side == rhs.side
    }
    
}
