//
//  NetworkConfig.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Foundation

struct NetworkConfig: Sendable {
    static let baseURL: URL = URL(string: "https://opentable-dex-ios-test-d645a49e3287.herokuapp.com")!
    static let userId: String = "vulloa"

    var baseURL: URL
    var userId: String
    var defaultHeaders: [String: String]
    var timeout: TimeInterval

    init(
        userId: String = NetworkConfig.userId,
        baseURL: URL = NetworkConfig.baseURL,
        defaultHeaders: [String: String] = ["Accept": "application/json"],
        timeout: TimeInterval = 30
    ) {
        self.userId = userId
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
    }
}
