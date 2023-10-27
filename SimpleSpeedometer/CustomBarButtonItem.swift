//
//  CustomBarButtonItem.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/27/23.
//

import UIKit

class CustomBarButtonItem {
    var title: String?
    var image: UIImageView?
    var handler: () -> ()?

    init(title: String? = nil, image: UIImageView? = nil, handler: @escaping () -> ()?) {
        self.title = title
        self.image = image
        self.handler = handler
    }
}
