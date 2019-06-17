//
//  BookDatailsView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class BookDatailsView: UIViewController, BookDetailsViewDelegate {
    // User interface elements
    @IBOutlet weak var bookDetailsCarousel: UICollectionView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    // View internal elements
    private var presenter = BookDetailsViewPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        bookDetailsCarousel.delegate = self
        bookDetailsCarousel.dataSource = self
        setupUI()
        
    }
    
    func passBookToPresenter(book: Book) {
        presenter.setup(for: book)
    }
    
    func setupUI() {
        let book = presenter.getBookBeingDisplayed()
        
        if book.subtitle != nil {
            bookTitle.text = "\(book.title!)\n\(book.subtitle!)"
            
        } else {
            bookTitle.text = "\(book.title!)"
        }
        
        if book.author_name!.count > 1 {
            bookAuthor.text = "Multiple Authors"
            
        } else {
            bookAuthor.text = book.author_name!.joined()
        }
    }
    
    @IBAction func userPressedCloseButton(_ sender: Any) {
        presenter.closePopup()
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
    
}
