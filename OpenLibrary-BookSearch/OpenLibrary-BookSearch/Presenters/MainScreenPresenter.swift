//
//  MainScreenPresenter.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

protocol MainScreenPresenterDelegate: NSObjectProtocol {
    func updateTopBar(moveIndicatorToThe direction: Direction)
    func updateMainArea(withImage image: ImageMessage, withMessage message: Message )
    func updateBookList()
    func updatePreviewCell(at indexPath: IndexPath)
    func presentBookDetailPopup()
}

// MARK: Setup and helper functions
class MainScreenPresenter {
    // Connections to view and model manager
    weak var delegate: MainScreenPresenterDelegate?
    private let bookSearchManager = BookSearchManager()
    private let wishlistManager = WishlistManager()
    
    
    // Presenter internal state elements
    private var currentAppState = AppState.BookSearch
    private var bookSearchTimer = Timer()
    private var selectedBook: Book?
    private var selectedBookIndexPath: IndexPath!
    
    
    init(){
        setupObervers()
    }
    
    
    private func setupObervers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMainScreen), name: NSNotification.Name("update_main_screen_manager"), object: nil)
    }
}

// Functions called view
extension MainScreenPresenter {
    func changeAppState(to state: AppState) {
        // Changing app state
        if state == currentAppState {
            return
            
        } else {
            currentAppState = state
        }
        
        // Making necessary calls to update view
        switch state {
        case .BookSearch:
            delegate?.updateTopBar(moveIndicatorToThe: .Left)
            delegate?.updateMainArea(withImage: .SearchForBooks, withMessage: .SearchForBooks)
            
        case .Wishlist:
            delegate?.updateTopBar(moveIndicatorToThe: .Right)
            
            if wishlistManager.getWishlistCount() == 0 {
                delegate?.updateMainArea(withImage: .SearchForBooks, withMessage: .SearchForBooksToAddToWishlist)
                
            } else {
                delegate?.updateBookList()
            }
        }
    }
    
    
    func requestBookSearch(for bookQuery: String) {
        if bookQuery != "" {
            bookSearchTimer.invalidate()
            bookSearchTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(beginRequest), userInfo: bookQuery, repeats: false)
            
        } else {
            return
        }
    }
    
    
    @objc func beginRequest() {
        if let bookQuery = bookSearchTimer.userInfo as? String {
            bookSearchManager.requestAPI(for: bookQuery) { (requestSucceeded) in
                if requestSucceeded {
                    self.delegate?.updateBookList()
                    
                } else {
                    self.delegate?.updateMainArea(withImage: .NoResultsFound, withMessage: .NoResultsFound)
                }
            }
        }
    }
    
    
    func requestBookCount() -> Int {
        switch currentAppState {
        case .BookSearch:
            return bookSearchManager.getBookResultsCount()
            
        case .Wishlist:
            return wishlistManager.getWishlistCount()
        }
    }
    
    
    func requestBook(atIndex index: Int) -> Book {
        let book: Book
        
        switch currentAppState {
        case .BookSearch:
            book = bookSearchManager.getBook(atIndex: index)
            
        case .Wishlist:
            book = wishlistManager.getBook(atIndex: index)
            
        }
        return book
    }
    
    
    func presentBookDetailPopup(at indexPath: IndexPath) {
        selectedBook = bookSearchManager.getBook(atIndex: indexPath.row)
        selectedBookIndexPath = indexPath
        delegate?.presentBookDetailPopup()
    }
    
    
    func getSelectedBook() -> Book {
        return selectedBook!
    }
    
    
    func getSelectedBookIndexPath() -> IndexPath {
        return selectedBookIndexPath!
    }
}

// Functions called by wishlist manager when updates occure
// FIXME:
extension MainScreenPresenter {
    @objc func updateMainScreen(notification: NSNotification) {
        print("HHHHHH")
        if let updateType = notification.userInfo?["update_type"] as? String {
            print("HERE1")
            if updateType == "update_preview_cell" {
                if let bookIndexPath = notification.userInfo?["book_index_path"] as? IndexPath {
                    delegate?.updatePreviewCell(at: bookIndexPath)
                }
                
            } else if updateType == "update_booklist" {
                print("print(\(currentAppState))")
                if currentAppState == .Wishlist {
                    if wishlistManager.getWishlistCount() == 0 {
                        print("------------")
                        delegate?.updateMainArea(withImage: .SearchForBooks, withMessage: .SearchForBooksToAddToWishlist)
                        
                    } else {
                        delegate?.updateBookList()
                    }
                }
            }
        }
    }
}
