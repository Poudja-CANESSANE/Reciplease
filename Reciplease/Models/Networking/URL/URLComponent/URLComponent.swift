//
//  URLComponent.swift
//  Reciplease
//
//  Created by Canessane Poudja on 26/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import Foundation

protocol URLComponent {
    func getBaseUrl(fromString: String) -> URLComponents?
}
