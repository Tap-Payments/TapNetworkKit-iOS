//
//  TestCaseType.swift
//  TapNetworkKit-Example
//
//  Created by Kareem Ahmed on 8/6/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation

enum TestCaseType {
    case successGetRequestWithoutHeaders
    case successGetRequestWithHeaders
    case failedGetRequestWithoutHeadersWithoutErrorModel
    case failedGetRequestWithoutHeadersWithErrorModel
    case successPostRequestWithHeaders
    case successPostRequestWithoutHeaders
    case failedPostRequestWithHeaders
}
