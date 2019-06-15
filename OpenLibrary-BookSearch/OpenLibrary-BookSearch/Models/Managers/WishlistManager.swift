//
//  WishlistManager.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

class WishlistManager {
    private var wishList: [Any]  // FIXME:
    
    init() {
        wishList = []
    }
    
    func getWishlistCount() -> Int {
        return wishList.count
    }
}
