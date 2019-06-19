//
//  MainScreenView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

// Setup and user initiated events
class MainScreenView: UIViewController, MainScreenPresenterDelegate, UISearchBarDelegate {
    // User interface elements
    @IBOutlet weak var currentTabIndicator: UIImageView!
    @IBOutlet weak var bookSearchButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var bookSearchBar: UISearchBar!
    @IBOutlet weak var bookList: UITableView!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    
    // View internal elements
    private let presenter = MainScreenPresenter()
    
    
    // Inital view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        bookSearchBar.delegate = self
        bookList.delegate = self
        bookList.dataSource = self
    }
    
    
    // User initiated events
    @IBAction func userSelectedTab(_ sender: UIButton) {
        if let selectedTab = AppState(rawValue: sender.titleLabel!.text!) {
            presenter.changeAppState(to: selectedTab)
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let bookQuery = searchText
        
        presenter.requestBookSearch(for: bookQuery)
    }
}

// Function calls from presenter
extension MainScreenView {
    func updateTopBar(moveIndicatorToThe direction: Direction) {
        switch direction {
        case .Right:
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                    let translationY = -self.bookSearchBar.frame.height
                    
                    self.bookSearchBar.transform = CGAffineTransform(translationX: 0, y: translationY)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5, animations: {
                    let x = self.wishlistButton.frame.midX - (self.currentTabIndicator.frame.width / 2)
                    let y = self.currentTabIndicator.frame.origin.y
                    
                    self.currentTabIndicator.frame.origin = CGPoint(x: x, y: y)
                })
            }, completion: { (_) in
                self.bookSearchBar.text?.removeAll()
            })
        
        case .Left:
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    let x = self.bookSearchButton.frame.midX - (self.currentTabIndicator.frame.width / 2)
                    let y = self.currentTabIndicator.frame.origin.y
                    
                    self.currentTabIndicator.frame.origin = CGPoint(x: x, y: y)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3, animations: {
                    self.bookSearchBar.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            })
        }
    }
    
    
    func updateMainArea(withImage image: ImageMessage, withMessage message: Message) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.bookList.isHidden = true
            self.imageMessage.image = UIImage(named: image.rawValue)
            self.message.text = message.rawValue
        }
    }
    
    
    func updateBookList() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.bookList.isHidden = false
            self.bookList.reloadData()
        }
    }
    
    
    func presentBookDetailPopup() {
        performSegue(withIdentifier: "BookDetailsSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! BookDatailsView
        destinationView.passBookToPresenter(book: presenter.getSelectedBook(), bookIndexPath: presenter.getSelectedBookIndexPath())
    }
    
    
    func updatePreviewCell(at indexPath: IndexPath) {
        print("Final")
        DispatchQueue.main.async {
            print("Idex Path \(indexPath)")
            self.bookList.reloadData()
        }
    }
}


// Booklist internal functions
extension MainScreenView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.requestBookCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = presenter.requestBook(atIndex: indexPath.row)
        
        let bookPreviewCell = tableView.dequeueReusableCell(withIdentifier: "BookPreviewCell") as! BookPreviewCellView
        
        bookPreviewCell.setup(for: book, indexPath: indexPath)
        
        return bookPreviewCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.presentBookDetailPopup(at: indexPath)
        bookList.deselectRow(at: indexPath, animated: true)
    }
}
