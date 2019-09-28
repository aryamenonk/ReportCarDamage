//
//  CustomButton.swift
//  eKar
//
//  Created by Arya Menon K on 9/28/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit


class eKarButton : UIButton {
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .blue : .lightGray
            isUserInteractionEnabled = isEnabled
        }
    }
}
