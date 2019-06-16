//
//  BookPreviewCellView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class BookPreviewCellView: UITableViewCell {
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitles: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(for book: Book) {
        // Setting up book cover
        bookCover.image = UIImage(data: book.cover_data!)
        
        // Setting up book titles
        if book.subtitle != nil {
            bookTitles.text = "\(book.title!)\n\(book.subtitle!)"
            
        } else {
            bookTitles.text = "\(book.title!)"
        }
        
        // Setting up book authors
        if book.author_name!.count > 1 {
            bookAuthors.text = "Multiple Authors"
            
        } else {
            bookAuthors.text = book.author_name!.joined()
        }
    }

}
