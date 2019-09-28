//
//  BaseViewController.swift
//  eKar
//
//  Created by Arya Menon K on 9/28/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    // to hide keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
