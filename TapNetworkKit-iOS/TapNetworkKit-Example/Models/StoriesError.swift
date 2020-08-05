//
//  StoriesError.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/5/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

// MARK: - StoriesError
struct StoriesError: Codable {
    let fault: Fault
}

// MARK: - Fault
struct Fault: Codable {
    let faultstring: String
    let detail: Detail
}

// MARK: - Detail
struct Detail: Codable {
    let errorcode: String
}
