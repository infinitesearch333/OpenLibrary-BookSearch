//
//  Book.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/18/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Book: Object {
    dynamic var coverID: Int = Int.min
    dynamic var coverData: Data = Data()
    dynamic var title: String = ""
    dynamic var subtitle: String = ""
    dynamic var authorName: String = ""
    dynamic var firstPublishYear: Int = Int.min
    dynamic var publisher: String = ""
    dynamic var editionCount: Int = Int.min
    dynamic var isInWishlist: Bool = false

}
