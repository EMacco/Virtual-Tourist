//
//  Photo+Extension.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 19/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import MapKit

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
