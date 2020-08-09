//
//  ServiceContainerTests.swift
//  RecipleaseTests
//
//  Created by Canessane Poudja on 31/07/2020.
//  Copyright © 2020 Canessane Poudja. All rights reserved.
//

@testable import Reciplease
import XCTest

class ServiceContainerTests: XCTestCase {
    func testGetContext() {
        expectFatalError(expectedMessage: "Unresolved error Error Domain=RecipleaseTests.FakeResponseData.FakeResponseError Code=1 \"(null)\", [:]") {
            _ = ServiceContainer.getContext(fromContainer: ContainerStub(name: "Reciplease"),
                                            stopExecution: fatalError)
        }
    }
}
