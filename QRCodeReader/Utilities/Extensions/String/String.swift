//
//  String.swift
//  QRCodeReader
//
//  Created by Vladislav Zagorodnyuk on 1/9/18.
//  Copyright © 2018 Vladislav Zagorodnyuk. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func capitalizeFirst() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
