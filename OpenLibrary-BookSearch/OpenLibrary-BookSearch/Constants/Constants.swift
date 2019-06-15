//
//  Constants.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

public enum AppState: String {
    case BookSearch = "Book Search"
    case Wishlist = "Wishlist"
}

public enum Direction {
    case Left
    case Right
}

public enum ImageMessage: String {
    case SearchForBooks = "image_message_1"
    case NoResultsFound = "image_message_2"
}

public enum Message: String {
    case SearchForBooks = "Search for book!"
    case SearchForBooksToAddToWishlist = "Search for books to add to wishlist!"
    case NoResultsFound = "Sorry, Results Found"
}
