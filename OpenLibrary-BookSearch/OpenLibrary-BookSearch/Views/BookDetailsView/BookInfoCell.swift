//
//  BookInfoCell.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class BookInfoCell: UICollectionViewCell {
    var bookInfo = UILabel()
    
    func setupCell(for book: Book) {
        // Setting up asthetics
        bookInfo.textColor = UIColor(red: 47/255, green: 49/255, blue: 49/255, alpha: 100)
        bookInfo.font = UIFont(name: "Lato-Regular.ttf", size: 18)
        bookInfo.textAlignment = .center
        bookInfo.numberOfLines = 3
        bookInfo.text = "Publish Year: \(book.firstPublishYear)\nPublisher: \(book.publisher)\nEdition count: \(book.editionCount)"
        
        // Setting up constraints
        self.contentView.addSubview(bookInfo)
        
        bookInfo.translatesAutoresizingMaskIntoConstraints = false
        bookInfo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 1).isActive = true
        bookInfo.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 1).isActive = true
        
    }
}
