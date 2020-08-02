//
//  ContainerStub.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 31/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

import CoreData
@testable import Reciplease

class ContainerStub: NSPersistentContainer {
    override func loadPersistentStores(
        completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        block(NSPersistentStoreDescription(
            url: URL(string: "file:///dev/null")!),
              FakeResponseData.error)
    }
}
