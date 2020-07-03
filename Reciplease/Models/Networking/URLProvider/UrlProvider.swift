//
//  UrlProvider.swift
//  Reciplease
//
//  Created by Canessane Poudja on 27/06/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol UrlProvider {
    func getUrl(forFood food: String, fromMinIndex minIndex: Int, toMaxIndex maxIndex: Int) -> URL?
}
