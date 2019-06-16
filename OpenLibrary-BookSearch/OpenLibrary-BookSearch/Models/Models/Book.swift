//
//  Book.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

class Book: Decodable {
    let cover_i: Int?
    var cover_data: Data?
    
    let title: String?
    let subtitle: String?
    
    let author_name: [String]?
    
    let first_publish_year: Int?
    let publisher: [String]?
    
    let edition_count: Int?
}
