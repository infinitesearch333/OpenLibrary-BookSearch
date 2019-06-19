//
//  BookPreviewCellView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit
import RealmSwift

// Setup and user intiated events
class BookPreviewCellView: UITableViewCell {
    // User interface elements
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitles: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var wishlistButtonBackground: UIView!
    
    
    // Internal elements (Necessary for updating wishlist button)
    var bookBeingDisplayed: Book!
    var bookBeingDisplayedIndexPath: IndexPath!
    
    
    // Function sets up book preview cell user interface
    func setup(for book: Book, indexPath: IndexPath) {
        bookBeingDisplayed = book
        bookBeingDisplayedIndexPath = indexPath
        
        // Setting up user interface
        bookCover.image = UIImage(data: book.coverData)
        bookTitles.text = book.subtitle.isEmpty ? "\(book.title)" : "\(book.title)\n\(book.subtitle)"
        bookAuthors.text = book.authorName
        
        updateWishlistButtonUI()
        
    }
    
    func updateWishlistButtonUI() {
        // Setting up wishlist button
        if bookBeingDisplayed.isInWishlist {
            wishlistButtonBackground.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 100)
            wishlistButton.setTitleColor(UIColor(red: 47/255, green: 49/255, blue: 49/255, alpha: 100), for: .normal)
            wishlistButton.setImage(UIImage(named: "Wishlist_Check_Mark"), for: .normal)
            wishlistButton.imageEdgeInsets.left = -7
            wishlistButton.titleEdgeInsets.left = 4
            
        } else {
            wishlistButtonBackground.backgroundColor = UIColor(red: 90/255, green: 154/255, blue: 109/255, alpha: 100)
            wishlistButton.setTitleColor(UIColor.white, for: .normal)
            wishlistButton.setImage(nil, for: .normal)
            wishlistButton.imageEdgeInsets.left = 0
            wishlistButton.titleEdgeInsets.left = 0
        }
    }
    
    // User intiated events
    // FIXME:
    @IBAction func userPressedWishlistButton(_ sender: Any) {
        // Updating book's wishlist status
        let realm = try! Realm()
        
        try! realm.write {
            bookBeingDisplayed.isInWishlist = !bookBeingDisplayed.isInWishlist
        }

        updateWishlistButtonUI()
        
        // Notify wishlist to add or delete book
        let userInfo = ["book": bookBeingDisplayed!, "update" : "update_preview_cell", "book_index_path" : bookBeingDisplayedIndexPath!] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name("Update_Wishlist"), object: nil, userInfo: userInfo as [AnyHashable : Any])
    }
}
