//
//  BookDetailsViewPresenter.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
protocol BookDetailsViewDelegate: NSObjectProtocol {
    func dismissPopup()
    func updatePageController(to pageNum: Int)
}

class BookDetailsViewPresenter {
    private var bookBeingDesplayed: Book!
    private var numOfBookDetailSections = 0
    
    // Connections to view and model manager
    weak var delegate: BookDetailsViewDelegate?
    
    func setup(for book: Book) {
        bookBeingDesplayed = book
        numOfBookDetailSections = 2
    }
    
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
}
