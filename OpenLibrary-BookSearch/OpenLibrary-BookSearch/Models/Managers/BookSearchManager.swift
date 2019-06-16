//
//  BookSearchManager.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation

class BookSearchManager {
    // Book search manager internal elements
    private var bookResults: [Book]
    
    // Book search manager inital setup
    init() {
        bookResults = []
    }
    
    // Function will perform an API request for the given book query
    func requestAPI(for bookQuery: String, completion: @escaping (_ success: Bool) -> Void){
        // Optimizing book search
        let optimizedBookQuery = bookQuery.replacingOccurrences(of: " ", with: "+").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        requesBookInfo(for: optimizedBookQuery) { (success) in
            if success {
                self.requesBookCovers() {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
}
    
    // Function will attempt to request and structure a list of book information from Open Libray Api
    private func requesBookInfo(for bookQuery: String, completion: @escaping (_ success: Bool) -> Void) {
        // Setting up api book info request url and JSON decoder
        let bookInfoRequestURL = "http://openlibrary.org/search.json?q=" + bookQuery
        let bookInfoRequestURLObj = URL(string: bookInfoRequestURL)
        let decoder = JSONDecoder()
        
        // Requesting book infomation
        URLSession.shared.dataTask(with: bookInfoRequestURLObj!) { (data, response, error) in
            if let dataJSON = data {
                let queryResults = try? decoder.decode(APIRequestResult.self, from: dataJSON)
                
                if let bookResultsDirty = queryResults?.docs {
                    if bookResultsDirty.count != 0{
                        // Cleaning book results
                        self.bookResults = bookResultsDirty.filter {$0.cover_i != nil && $0.title != nil && $0.author_name != nil && $0.first_publish_year != nil && $0.publisher != nil && $0.edition_count != nil}
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    
    // Function will attempt to request and structure a list of book information from Open Libray API
    private func requesBookCovers(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for book in self.bookResults {
            // Setting up api book cover url
            let bookCoverRequestURL = "http://covers.openlibrary.org/b/id/\(book.cover_i!)-M.jpg"
            let bookCoverRequestURLObj = URL(string: bookCoverRequestURL)
            
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: bookCoverRequestURLObj!) { (data, response, error) in
                book.cover_data = data
                dispatchGroup.leave()
            }.resume()
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            completion()
        }
    }
    
    func getBookResultsCount() -> Int {
        return bookResults.count
    }
    
    func getBook(atIndex index: Int) -> Book {
        return bookResults[index]
    }
}
