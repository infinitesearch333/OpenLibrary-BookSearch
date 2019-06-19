//
//  BookDatailsView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

// Setup and user intiated events
class BookDatailsView: UIViewController, BookDetailsViewDelegate {
    // User interface elements
    @IBOutlet weak var bookDetailsCarousel: UICollectionView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var wishlistButtonBackground: UIView!
    
    
    // View internal elements
    private var presenter = BookDetailsViewPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        bookDetailsCarousel.delegate = self
        bookDetailsCarousel.dataSource = self
        setupUI()
        
    }
    
    
    func passBookToPresenter(book: Book, bookIndexPath indexPath: IndexPath) {
        presenter.setup(for: book, bookIndex: indexPath)
    }
    
    
    func setupUI() {
        let book = presenter.getBookBeingDisplayed()
        
        if book.subtitle.isEmpty {
            bookTitle.text = "\(book.title)"
            
        } else {
            bookTitle.text = "\(book.title)\n\(book.subtitle)"
        }
        
        bookAuthor.text = book.authorName
        
        updateWishlistButtonUI()
    }
    
    
    // User initiated events
    @IBAction func userPressedCloseButton(_ sender: Any) {
        presenter.closePopup()
    }
    
    
    @IBAction func userPressedWishlistButton(_ sender: Any) {
        presenter.notifyWishlistOfUpdate()
        
    }
}

// Book details carousel internal functionality
extension BookDatailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNumberofDetailSections()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Setting up carousel book detail sections
        let detailSectionNum = indexPath.row
        
        // Presenting book cover
        if detailSectionNum == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCell", for: indexPath) as! BookCoverCell
            
            cell.setupCell(for: presenter.getBookBeingDisplayed())
            
            return cell
        }
        
        // Presenting book details
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookInfoCell", for: indexPath) as! BookInfoCell
            
            cell.setupCell(for: presenter.getBookBeingDisplayed())
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.bookDetailsCarousel.frame.width, height: self.bookDetailsCarousel.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.infoPageChanged(to: indexPath.row)
    }
}

// Function calls from presenters
extension BookDatailsView {
    func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updatePageController (to pageNum: Int) {
        pageController.currentPage = pageNum
    }
    
    
    func updateWishlistButtonUI() {
        let bookBeingDisplayed = presenter.getBookBeingDisplayed()
        
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
    
}
