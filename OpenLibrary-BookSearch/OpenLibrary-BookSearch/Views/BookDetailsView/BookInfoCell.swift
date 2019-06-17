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
        bookInfo.textColor = UIColor(red: 47/255, green: 49/255, blue: 49/255, alpha: 100)
        bookInfo.font = UIFont(name: "Lato-Regular.ttf", size: 18)
        bookInfo.textAlignment = .center
        bookInfo.numberOfLines = 3
        
        self.contentView.addSubview(bookInfo)
   
        if book.publisher!.count > 1 {
            bookInfo.text = "Publish Year: \(book.first_publish_year!)\nPublisher: Multiple\nEdition count: \(book.edition_count!)"
            
        } else {
            bookInfo.text = "Publish Year: \(book.first_publish_year!)\nPublisher: \(book.publisher!.joined())\nEdition count: \(book.edition_count!)"
        }
        
        bookInfo.translatesAutoresizingMaskIntoConstraints = false
        bookInfo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 1).isActive = true
        bookInfo.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 1).isActive = true
        
    }
}
