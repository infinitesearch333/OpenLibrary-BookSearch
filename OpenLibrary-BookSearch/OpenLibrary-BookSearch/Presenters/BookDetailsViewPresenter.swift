//
//  BookDetailsViewPresenter.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
import RealmSwift

protocol BookDetailsViewDelegate: NSObjectProtocol {
    func dismissPopup()
    func updatePageController(to pageNum: Int)
    func updateWishlistButtonUI()
}

// Setup and helper functions
class BookDetailsViewPresenter {
    private var bookBeingDesplayed: Book!
    private var bookBeingDisplayedIndex: IndexPath!
    private var numOfBookDetailSections = 0
    
    // Connections to view and model manager
    weak var delegate: BookDetailsViewDelegate?
    
    func setup(for book: Book, bookIndex index: IndexPath) {
        bookBeingDesplayed = book
        bookBeingDisplayedIndex = index
        numOfBookDetailSections = 2
    }
}

// Functions called by view
extension BookDetailsViewPresenter {
    func closePopup() {
        delegate?.dismissPopup()
    }
    
    
    func getNumberofDetailSections() -> Int {
        return numOfBookDetailSections
    }
    
    
    func getBookBeingDisplayed() -> Book {
        return bookBeingDesplayed
    }
    
    
    func infoPageChanged(to pageNum: Int) {
        delegate?.updatePageController(to: pageNum)
    }
    
    
    // FIXME:
    func notifyWishlistOfUpdate() {
        // Updating book's wishlist status
        let realm = try! Realm()
        
        try! realm.write {
            bookBeingDesplayed.isInWishlist = !bookBeingDesplayed.isInWishlist
        }

        
        delegate?.updateWishlistButtonUI()
        
        // Notify wishlist manager
        let userInfo = ["book": bookBeingDesplayed!, "bookIndexPath": bookBeingDisplayedIndex!, "update_type" : "update_preview_cell"] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name("Update_Wishlist"), object: nil, userInfo: userInfo as [AnyHashable : Any])
    }
}
