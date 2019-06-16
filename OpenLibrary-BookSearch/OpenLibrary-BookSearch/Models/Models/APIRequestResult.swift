//
//  APIRequestResult.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

// Open library api requests will return a list of JSON data
// JSON data will be decoded and mapped into a Book structure
struct APIRequestResult: Decodable {
    var docs: [Book]
}
