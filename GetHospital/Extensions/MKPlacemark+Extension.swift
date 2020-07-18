//
//  MKPlacemark.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 14/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
