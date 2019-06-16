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
}

class MainScreenPresenter {
    // Connections to view and model manager
    weak var delegate: MainScreenPresenterDelegate?
    private let bookSearchManager = BookSearchManager()
    private let wishlistManager = WishlistManager()
    
    // Presenter internal state elements
    private var currentAppState = AppState.BookSearch
    private var bookSearchTimer = Timer()
    
    
    
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
                // FIXME: Update view's book list with wishlist books
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
            // FIXME: CALL API
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
            return bookSearchManager.getBookResultsCount()
        }
    }
    
    func requestBook(atIndex index: Int) -> Book {
        return bookSearchManager.getBook(atIndex: index)
    }
}
