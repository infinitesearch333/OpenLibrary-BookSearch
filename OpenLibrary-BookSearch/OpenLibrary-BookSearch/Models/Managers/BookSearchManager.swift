//
//  BookSearchManager.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: Setup and helper functions
class BookSearchManager {
    // Book search manager internal elements
    private var bookResults: [Book] = []
    

    // Function will attempt to request and structure a list of books obtained from api request
    private func requesBookInfo(for bookQuery: String, completion: @escaping (_ success: Bool) -> Void) {
        bookResults.removeAll()
        
        // Setting up api book info request url
        let bookInfoRequestURL = "http://openlibrary.org/search.json?q=" + bookQuery
        let bookInfoRequestURLObj = URL(string: bookInfoRequestURL)
        
        // Requesting book infomation
        URLSession.shared.dataTask(with: bookInfoRequestURLObj!) { (data, response, error) in
            // TEST
            guard let obtainedData = data else {
                print("No data obtained from api request")
                return
            }
            
            guard let jsonDataDictionary = try? JSONSerialization.jsonObject(with: obtainedData, options: .mutableContainers) as? [String:Any] else {
                print("Error converting ontained data from api to a dictionary")
                return
            }
            
            guard let bookResultsJSON = jsonDataDictionary["docs"] as? [[String:Any]] else {
                print("Error extracting book results")
                return 
            }
            
            if bookResultsJSON.isEmpty {
                completion(false)
                return
            }
            
            // Cleaning book results
            var cleanBookResults: [[String:Any]] = []
            for book in bookResultsJSON {
                if book["cover_i"] != nil && book["title"] != nil && book["author_name"] != nil && book["first_publish_year"] != nil && book["publisher"] != nil && book["edition_count"] != nil {
                    cleanBookResults.append(book)
                }
            }
            
            // Extracting data from clean book results and structuring book objects
            for book in cleanBookResults {
                let newBook = Book()
                
                newBook.coverID = book["cover_i"] as! Int
                newBook.title = book["title"] as! String
                newBook.firstPublishYear = book["first_publish_year"] as! Int
                newBook.editionCount = book["edition_count"] as! Int
                
                let tempBookAuthorsList = book["author_name"] as! [String]
                newBook.authorName = tempBookAuthorsList.count > 1 ? "Multiple" : tempBookAuthorsList.joined()
        
            
                let tempPublihsersList = book["publisher"] as! [String]
                newBook.publisher = tempPublihsersList.count > 1 ? "Multiple" : tempPublihsersList.joined()
                
                if book.keys.contains("subtitle") {
                    newBook.subtitle = book["subtitle"] as! String
                }
                
                self.bookResults.append(newBook)
            }
            completion(true)
        }.resume()
    }
    
    
    // Function will attempt to request and structure a list of book information from Open Libray API
    private func requesBookCovers(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for book in self.bookResults {
            // Setting up api book cover url
            let bookCoverRequestURL = "http://covers.openlibrary.org/b/id/\(book.coverID)-M.jpg"
            let bookCoverRequestURLObj = URL(string: bookCoverRequestURL)
            
            // Requesting book covers
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: bookCoverRequestURLObj!) { (data, response, error) in
                if let imageData = data {
                    book.coverData = imageData
                    dispatchGroup.leave()
                }
            }.resume()
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            completion()
        }
    }
    
    
    // Function determines which of the result books are in the wishlist
    private func determineWishlistBooks(completion: () -> Void) {
        let realm = try! Realm()
    
        for book in bookResults {
            if realm.objects(Book.self).filter("coverID == \(book.coverID)").count != 0 {
                book.isInWishlist = true
            }
        }
        completion()
    }
}

// MARK: Functions called by presenter
extension BookSearchManager {
    // Function will perform an api request for the given book query
    func requestAPI(for bookQuery: String, completion: @escaping (_ success: Bool) -> Void){
        // Optimizing book search
        let optimizedBookQuery = bookQuery.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Attempting to preform api request
        requesBookInfo(for: optimizedBookQuery) { (success) in
            if success {
                self.requesBookCovers() {
                    self.determineWishlistBooks {
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }

    
    func getBookResultsCount() -> Int {
        return bookResults.count
    }
    
    
    func getBook(atIndex index: Int) -> Book {
        return bookResults[index]
    }
}
