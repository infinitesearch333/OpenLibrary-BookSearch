//
//  BookSearchManager.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

class BookSearchManager {
    private var bookResults: [Any]  // FIXME:
    
    init() {
        bookResults = []
    }
    
    func getBookResultsCount() -> Int {
        return bookResults.count
    }
}
