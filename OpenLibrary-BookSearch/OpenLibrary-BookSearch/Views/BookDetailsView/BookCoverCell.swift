//
//  BookCoverCell.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/16/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    let bookCover = UIImageView()
    
    func setupCell(for book: Book) {
        // Setting up asthetics
        bookCover.image = UIImage(data: book.coverData)
        
        self.contentView.addSubview(bookCover)
        
        // Setting up constraints
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        bookCover.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 1).isActive = true
        bookCover.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 1).isActive = true
        bookCover.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.43).isActive = true
        bookCover.heightAnchor.constraint(equalTo: bookCover.widthAnchor, multiplier: 211/130).isActive = true
    }
}
