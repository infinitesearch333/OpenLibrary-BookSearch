//
//  WishlistManager.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: Setup and helper functions
class WishlistManager {
    // Wishlist manager internal elements
    private var wishList: [Book]
    let realm = try! Realm()
    

    init() {
        wishList = Array(realm.objects(Book.self))
        setupObervers()
    }
    
    
    private func setupObervers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addOrDeleteBookFromWishlist), name: NSNotification.Name("Update_Wishlist"), object: nil)
    }
}

// MARK: Functions called by wishlist buttons
// FIXME:
extension WishlistManager{
    @objc func addOrDeleteBookFromWishlist(notification: NSNotification) {
        
        // Extracting book that will be added to or deleted from wishlist
        if let book = notification.userInfo?["book"] as? Book {
            
            // Determining action
            // Book marked to be in wishlist --> Remove
            // Book marked not to be in wishlist --> Add
            if book.isInWishlist {
                if realm.objects(Book.self).filter("coverID == \(book.coverID)").count == 0 {
                    // Creating a copy of book to add to realm db (Done to avoid realm errors)
                    let realmBook = Book()
                    realmBook.authorName = book.authorName
                    realmBook.title = book.title
                    realmBook.coverData = book.coverData
                    realmBook.coverID = book.coverID
                    realmBook.editionCount = book.editionCount
                    realmBook.firstPublishYear = book.firstPublishYear
                    realmBook.isInWishlist = book.isInWishlist
                    realmBook.publisher = book.publisher
                    
                    try! realm.write {
                        realm.add(realmBook)
                    }
                    
                    // Getting new wishlist
                    wishList = Array(realm.objects(Book.self))
                }
            } else {
                try! realm.write {
                    let objectsToDelete = realm.objects(Book.self).filter("coverID == \(book.coverID)")
                    realm.delete(objectsToDelete)
                }
                
                // Getting new wishlist
                wishList = Array(realm.objects(Book.self))
                
                // Notifying presenter of a change
                let userInfo = ["update_type": "update_booklist"]
                
                NotificationCenter.default.post(name: NSNotification.Name("update_main_screen_manager"), object: nil, userInfo: userInfo as [AnyHashable : Any])
            }
        }
    }
}

// MARK: Functions called by presenter
extension WishlistManager {
    func getWishlistCount() -> Int {
        return wishList.count
    }
    
    
    func getBook(atIndex index: Int) -> Book {
        return wishList[index]
    }
}

