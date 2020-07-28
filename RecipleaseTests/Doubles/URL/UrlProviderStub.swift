//
//  UrlProviderStub.swift
//  Reciplease
//
//  Created by Canessane Poudja on 17/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation
@testable import Reciplease

class UrlProviderStub: UrlProvider {
    func getUrlString(forFood food: String, fromMinIndex minIndex: Int, toMaxIndex maxIndex: Int) -> String? {
        return nil
    }
}
