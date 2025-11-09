//
//  NetworkConfig.swift
//  OpenFoods
//
//  Created by Victor Ulloa on 2025-11-07.
//

import Foundation

struct NetworkConfig: Sendable {
    static let baseURLString = "https://opentable-dex-ios-test-d645a49e3287.herokuapp.com"
    static let userIdValue = "vulloa"

    static var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            preconditionFailure("Invalid base URL string: \(baseURLString)")
        }
        return url
    }

    var userId: String
    var baseURL: URL
    var headers: [String: String]
    var timeout: TimeInterval

    init(
        userId: String = NetworkConfig.userIdValue,
        baseURL: URL = NetworkConfig.baseURL,
        headers: [String: String] = ["Accept": "application/json"],
        timeout: TimeInterval = 30
    ) {
        self.userId = userId
        self.baseURL = baseURL
        self.headers = headers
        self.timeout = timeout
    }
}
